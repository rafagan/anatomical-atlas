using System;
using System.Collections.Generic;
using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class SelectionManager : MonoBehaviour
{
    public Transform Pivot;
    public Material SelectionMaterial;
    public Material FadeMaterial;
    public Material OriginalMaterial, OriginalMaterialTransparent;
	public Boolean isFaded = false;
	public Boolean isHidden = false;

	public static bool IsZooming;

    private HashSet<AbstractStructure> _selectedStructures;
    private HashSet<AbstractStructure> _disabled, _disabledOthers;
    private HashSet<AbstractStructure> _faded, _fadedOthers;
	private BoneTouch _boneTouch;

	private AbstractStructure currentStructure;

    private bool _ignoreTouch, _ignoreMouseClick;

    void Awake() {
        _selectedStructures = new HashSet<AbstractStructure>();
        _disabled = new HashSet<AbstractStructure>();
        _faded = new HashSet<AbstractStructure>();
		_fadedOthers = new HashSet<AbstractStructure>();
		_disabledOthers = new HashSet<AbstractStructure>();
		_boneTouch = new BoneTouch();

        if (SystemInfo.deviceType != DeviceType.Handheld)
            _ignoreMouseClick = true;

        Pivot = GameObject.Find("Pivot").transform;
    }

    void OnGUI() 
	{
        var e = Event.current;

        if (Input.touchCount > 1 || _boneTouch.HasPanMoved())
            _ignoreTouch = true;
        else if (Input.touchCount == 0)
            _ignoreTouch = false;

		if (Reset.IsReseting) return;

        if (e.isMouse && e.type == EventType.MouseDown && e.clickCount == 2 && _boneTouch.HasClick(MouseButton.Left)) 
		{
			var clicked = _boneTouch.TraceRaycastByMouseClick();
			if(!clicked) 
			{
				ClearSelection();
				SendInformationToXCode.ClearSignal();
				return;
			}
			TestTouch(clicked);
			TraceRayToBone();
        } 
		else if (!_ignoreTouch && e.clickCount == 1 && _boneTouch.HasPan()) 
		{
			var clicked = _boneTouch.TraceRaycastByTouch();
			if(!clicked)
			{ 
				ClearSelection();
				currentStructure = null;
				SendInformationToXCode.ClearSignal();
				return;
			}

			TestTouch(clicked);
            TraceRayToBone();
        }
    }

    void TraceRayToBone() {
		if (IsZooming) return;
		IsZooming = true;
        RaycastHit hit;
        var ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        Physics.Raycast(ray, out hit, Mathf.Infinity);
        Pivot.position = hit.point;
        StartCoroutine(CamMoveTo());
    }

    IEnumerator CamMoveTo() {
        var threshold = (int)Mathf.Clamp(GlobalVariables.ZoomThreshold, GlobalVariables.ZoomNearLimit, GlobalVariables.ZoomFarLimit);
        var camPos = Camera.main.transform.position;
        var camPosF = camPos + (Pivot.position - camPos) + new Vector3(0, 0, -threshold);

        while ((camPosF - camPos).sqrMagnitude > Mathf.Pow(threshold, 2)) {
			if(Reset.IsReseting) break;

            camPos = Camera.main.transform.position;
            Camera.main.transform.position = Vector3.Lerp(camPos, camPosF, Time.deltaTime * GlobalVariables.ZoomSpeedDClick);
            yield return new WaitForEndOfFrame();
        }
		IsZooming = false;
    }

	private void ClearSelection() 
	{
		foreach (var ss in _selectedStructures) 
		{
			if(_disabled.Contains(ss) || _disabledOthers.Contains(ss)) continue;

			if(_faded.Contains(ss) || _fadedOthers.Contains(ss)) ss.renderer.material = OriginalMaterialTransparent;
			else ss.renderer.material = OriginalMaterial;
		}
		
		_selectedStructures.Clear();
	}
	
	public void TestTouch(GameObject touchedByRay) 
	{
		if ((touchedByRay.tag != "bone" && touchedByRay.tag != "boneset" && touchedByRay.tag != "bonepart")) 
		{
			ClearSelection();
			SendInformationToXCode.ClearSignal();
		}

		currentStructure = touchedByRay.GetComponent<AbstractStructure>();
		
		ClearSelection ();
		_selectedStructures.Add(currentStructure);
		currentStructure.renderer.material = SelectionMaterial;

		if(_faded.Contains(currentStructure) || _fadedOthers.Contains(currentStructure)) isFaded = true;
		if(_disabled.Contains(currentStructure) || _disabledOthers.Contains(currentStructure)) isHidden = true;
			
		SendInformationToXCode.PassInformation (currentStructure.name, isFaded, isHidden);
	}

    public void Fade() {
        foreach (var ss in _selectedStructures) {
            _faded.Add(ss);
            ss.renderer.material = FadeMaterial;
        }
    }

    public void Hide() 
	{
		if(_selectedStructures.Count == 0)
			return;

        foreach (var ss in _selectedStructures) 
		{
            _disabled.Add(ss);
			_faded.Remove(ss);
			if(_fadedOthers.Contains(ss)) _fadedOthers.Remove(ss);
            ss.renderer.material = OriginalMaterial;
            ss.gameObject.SetActive(false);
        }
        _selectedStructures.Clear();
    }

    public void ShowHide() 
	{
		if(currentStructure == null) return;
		if (_disabled.Contains (currentStructure)) currentStructure.gameObject.SetActive(true);
		currentStructure.renderer.material = SelectionMaterial;
		_selectedStructures.Add(currentStructure);
		_disabled.Clear();
		isHidden = false;
		isFaded = false;
    }

	public void ShowHideOthers() 
	{
		var skeleton = GameObject.Find("Skeleton");
		ShowHideOthersHelper(skeleton.transform);
		_disabledOthers.Clear ();
	}

    public void HideOthers() {
        var skeleton = GameObject.Find("Skeleton");
        HideOthersHelper(skeleton.transform);
		_fadedOthers.Clear ();
    }

    public void FadeOthers() {
        var skeleton = GameObject.Find("Skeleton");
        FadeOthersHelper(skeleton.transform);
    }

    private void HideOthersHelper(Transform t) 
	{
        var ss = t.gameObject.GetComponent<AbstractStructure>();

        if (ss) {
            if(_selectedStructures.Contains(ss) || _disabled.Contains(ss)) return;

			if(_faded.Contains(ss)) ss.renderer.material = OriginalMaterialTransparent;
			else ss.renderer.material = OriginalMaterial;

            _disabledOthers.Add(ss);
            ss.gameObject.SetActive(false);
        }

        if (t.childCount <= 0) return;

        foreach (Transform u in t) {
            HideOthersHelper(u);
        }
    }

    private void FadeOthersHelper(Transform t) {
        var ss = t.gameObject.GetComponent<AbstractStructure>();

        if (ss) {
			if(_selectedStructures.Contains(ss) || _disabled.Contains(ss)) return;

            _fadedOthers.Add(ss);
            ss.renderer.material = OriginalMaterialTransparent;
        }

        if (t.childCount <= 0) return;

        foreach (Transform u in t) {
            FadeOthersHelper(u);
        }
    }

	private void ShowHideOthersHelper(Transform t) {
		var ss = t.gameObject.GetComponent<AbstractStructure>();
		
		if (ss) {
			if(_selectedStructures.Contains(ss)) return;
			if(_faded.Contains(ss)) ss.renderer.material = OriginalMaterialTransparent;
			else ss.renderer.material = OriginalMaterial;
			ss.gameObject.SetActive(true);
		}
		
		if (t.childCount <= 0) return;
		
		foreach (Transform u in t) {
			ShowHideOthersHelper(u);
		}
	}

    public void ResetMaterials() 
	{
        foreach (var hide in _disabled) {
            hide.gameObject.SetActive(true);
        }
        foreach (var faded in _faded) {
            faded.renderer.material = OriginalMaterial;
        }
		foreach (var fadedOthers in _fadedOthers) {
			fadedOthers.renderer.material = OriginalMaterial;
		}
		foreach (var hideOthers in _disabledOthers) {
			hideOthers.gameObject.SetActive(true);
		}
		_faded.Clear();
		_disabled.Clear();
		_fadedOthers.Clear ();
		_disabledOthers.Clear ();
		currentStructure = null;
		isHidden = false;
		isFaded = false;
    }
}