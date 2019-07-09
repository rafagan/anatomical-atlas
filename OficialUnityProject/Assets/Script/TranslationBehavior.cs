using UnityEngine;
using System.Collections;

public class TranslationBehavior : MonoBehaviour {
    private Vector3 _lastMousePos;
    private float _distWeight;

	void Start () {
        _lastMousePos = Input.mousePosition;
	}
	
	void Update () {
        if(Reset.IsReseting) return;

	    if (Input.touchCount == 0 && Input.GetMouseButton((int)MouseButton.Right)) {
            var motionDelta = -(Input.mousePosition - _lastMousePos);
            motionDelta = (motionDelta * Mathf.Max(_distWeight, 0.15f) * GlobalVariables.TranslationSpeed * Time.deltaTime);
            transform.Translate(motionDelta);
	    } else if (Input.touchCount == 3) {
            var touchZero = Input.GetTouch(0);
	        const float mouseFactor = 0.17f;
            transform.Translate((-touchZero.deltaPosition * Mathf.Max(_distWeight, 0.1f)) * GlobalVariables.TranslationSpeed * Time.deltaTime * mouseFactor);
	    }

        _lastMousePos = Input.mousePosition;
        var zoomDistance = -Camera.main.transform.position.z;
        _distWeight = (zoomDistance - GlobalVariables.ZoomNearLimit) / (GlobalVariables.ZoomFarLimit - GlobalVariables.ZoomNearLimit);
        _distWeight = Mathf.Clamp01(_distWeight);
	}
}
