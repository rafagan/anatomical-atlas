using System;
using UnityEngine;
using System.Collections;

public class Reset : MonoBehaviour {
    public Vector3 OriginalPos;
    public Quaternion OriginalRotation;
    public static bool IsReseting;
    public Transform Pivot;

    public static bool RunningObjTranslation;

	private bool _resetMsgFromXcode;

    void Awake() {
        OriginalPos = Camera.main.transform.position;
        OriginalRotation = transform.rotation;
    }
	
	void Update () 
	{
		if (!_resetMsgFromXcode && !Input.GetKeyDown(KeyCode.Space)) return;

		_resetMsgFromXcode = false;
	    IsReseting = true;

        ResetMaterials();
        ResetTransform(OriginalRotation, null, OriginalPos, Vector3.zero, null);
	}

    public void ResetMaterials() 
	{
        GameObject.Find("AppManager").GetComponent<SelectionManager>().ResetMaterials();
    }

    public void ResetTransform(Quaternion destRot, SphericalCoordinates worldCoord, Vector3 destZoom, Vector3 destPos, Pivot p) {
        StartCoroutine(InterpolateRotation(destRot, worldCoord));
        StartCoroutine(InterpolateTranslation(destZoom));
        StartCoroutine(InterpolateModelTranslation(destPos, p));
        StartCoroutine(ResetFinished());
    }

    public IEnumerator ResetFinished() {
        while (_runningRotation || _runningTranslation || _runningTranslationObj) {
            yield return null;
        }
        IsReseting = false;
    }

    public IEnumerator InterpolateRotation(Quaternion destiny, SphericalCoordinates world) {
        if (_runningRotation) yield break;
        _runningRotation = true;

        var angle = Mathf.Infinity;
        const int threshold = 1;
        var t = gameObject.transform;

        while (angle > threshold) {
            angle = Quaternion.Angle(t.rotation, destiny);
            t.rotation =
                Quaternion.Slerp(t.rotation, destiny, GlobalVariables.ResetRotationSpeed*Time.deltaTime);
            yield return new WaitForEndOfFrame();
        }

        gameObject.transform.rotation = destiny;

        var rotBehavior = gameObject.GetComponent<RotationBehavior>();
        if (world != null) rotBehavior.World.SetRotation(world.Azimuth,world.Elevation);
        else rotBehavior.World.SetRotation(0, 0);
        _runningRotation = false;
    }

    private bool StopReseting() {
        return Input.GetMouseButton((int)MouseButton.Left) || Input.GetMouseButton((int)MouseButton.Right) || Input.touchCount > 0;
    }

    private static bool _runningTranslation, _runningRotation, _runningTranslationObj;
    public IEnumerator InterpolateTranslation(Vector3 destiny) {
        if(_runningTranslation) yield break;
        _runningTranslation = true;

        while ((destiny - Camera.main.transform.position).sqrMagnitude > 0.001f) {
            Camera.main.transform.position =
                Vector3.Lerp(Camera.main.transform.position, destiny, GlobalVariables.ResetTranslationSpeed * Time.deltaTime);
            yield return new WaitForEndOfFrame();
        }

        Camera.main.transform.position = destiny;
        _runningTranslation = false;
    }

    public IEnumerator InterpolateModelTranslation(Vector3 destiny, Pivot pivot) {
        if (_runningTranslationObj) yield break;
        _runningTranslationObj = true;

        while ((destiny-transform.position).sqrMagnitude > 0.001f) {
            transform.position =
                Vector3.Lerp(transform.position, destiny, GlobalVariables.ResetTranslationSpeed * Time.deltaTime);
            yield return new WaitForEndOfFrame();
        }

        transform.position = destiny;
        if (pivot == null) gameObject.GetComponent<RotationBehavior>().InitPivot();
        else Pivot.position = pivot.Position;
        _runningTranslationObj = false;
    }

	void PassToReset() {
		_resetMsgFromXcode = true;
	}
}