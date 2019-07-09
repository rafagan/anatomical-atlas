using UnityEngine;
using System.Collections;

public class ZoomBehavior : MonoBehaviour {
    void Update() {
        if (camera.isOrthoGraphic || Reset.IsReseting) return;

        var deltaMagnitudeDiff = 0.0f;

        if (!Mathf.Approximately(Input.GetAxis("Mouse ScrollWheel"),0.0f)) {
            deltaMagnitudeDiff += Input.GetAxis("Mouse ScrollWheel") * GlobalVariables.ZoomSpeedScroll * Time.deltaTime;
        } else if (Input.touchCount == 2) {
            var touchZero = Input.GetTouch(0);
            var touchOne = Input.GetTouch(1);

            // Find the position in the previous frame of each touch.
            var touchZeroPrevPos = touchZero.position - touchZero.deltaPosition;
            var touchOnePrevPos = touchOne.position - touchOne.deltaPosition;

            // Find the magnitude of the vector (the distance) between the touches in each frame.
            var prevTouchDeltaMag = (touchZeroPrevPos - touchOnePrevPos).magnitude;
            var touchDeltaMag = (touchZero.position - touchOne.position).magnitude;

            // Find the difference in the distances between each frame.
            deltaMagnitudeDiff = prevTouchDeltaMag - touchDeltaMag;
            deltaMagnitudeDiff *= GlobalVariables.ZoomSpeedPinch * Time.deltaTime;
        }

        var camPos = camera.transform.position;
        camPos.z = 0;
        camera.transform.Translate(new Vector3(0, 0, 1) * -deltaMagnitudeDiff + camPos);
        //var zoom = Mathf.Clamp(camera.transform.position.z, -GlobalVariables.ZoomFarLimit, -GlobalVariables.ZoomNearLimit);
		camera.transform.position = camPos + new Vector3(0,0,camera.transform.position.z);
    }
}
