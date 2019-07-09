using UnityEngine;
using System.Collections;

public enum MouseButton { Left = 0, Right = 1}

public class BoneTouch {
	public GameObject TraceRaycastByMouseClick() 
	{
		RaycastHit hit;
		var ray = Camera.main.ScreenPointToRay (Input.mousePosition);
		return Physics.Raycast (ray, out hit, Mathf.Infinity) ? hit.collider.gameObject : null;
	}

	public GameObject TraceRaycastByTouch() 
	{
		foreach(var i in Input.touches) {
            if (i.phase != TouchPhase.Ended) continue;
		    RaycastHit hit;
		    var ray = Camera.main.ScreenPointToRay (i.position);
		    return Physics.Raycast (ray, out hit, Mathf.Infinity) ? hit.collider.gameObject : null;
		}

		return null;
	}

	public bool HasPan() {
		if(SystemInfo.deviceType != DeviceType.Handheld)
			return false;

		foreach(var i in Input.touches)
            if (i.phase == TouchPhase.Ended) return true;
		return false;
	}

    public bool HasPanMoved() {
        if (SystemInfo.deviceType != DeviceType.Handheld)
            return false;

        foreach (var i in Input.touches)
            if (i.phase == TouchPhase.Moved) return true;
        return false;
    }

	public bool HasClick(MouseButton button) {
		return (SystemInfo.deviceType == DeviceType.Desktop && Input.GetMouseButtonDown((int) button));
	}
}
