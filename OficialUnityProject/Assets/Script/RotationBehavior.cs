using System;
using System.Collections;
using UnityEngine;

public class RotationBehavior : MonoBehaviour
{
    public Transform Pivot;
    public SphericalCoordinates World;

    private Vector3 _lastMousePos;
    private Vector3 _motionDelta;
    private Vector3 _orbitSpeed;

    void Awake()
    {
        World = new SphericalCoordinates(transform.position.normalized, 1f, 1f, 0, Mathf.PI * 2, -(Mathf.PI / 2) + 0.0001f, Mathf.PI / 2 - 0.0001f) 
        {
            LoopElevation = false
        };
         _lastMousePos = Input.mousePosition;

        Pivot = GameObject.Find("Pivot").transform;
        InitPivot();
    }

    void Update() {
        if (Reset.IsReseting) return;

        if (Input.touchCount == 0 && Input.GetMouseButton((int)MouseButton.Left)) {
            _motionDelta = Input.mousePosition - _lastMousePos;
            _motionDelta.x = -_motionDelta.x;

            if (_motionDelta.sqrMagnitude > Mathf.Epsilon)
                _orbitSpeed += _motionDelta * GlobalVariables.RotationSpeed * Time.deltaTime;
            else
                _orbitSpeed.Set(0, 0, 0);
        }
        else if (Input.touchCount == 1) {
            var f0 = Input.GetTouch(0);
            var f0Delta = new Vector3(-f0.deltaPosition.x, f0.deltaPosition.y, 0);

            if (f0.phase == TouchPhase.Moved)
                _orbitSpeed = f0Delta * GlobalVariables.RotationSpeed * Time.deltaTime;
            else
                _orbitSpeed.Set(0, 0, 0);
        }
        else {
            _orbitSpeed.Set(0,0,0);
        }

        if (Mathf.Approximately(Pivot.position.sqrMagnitude, 0)) {
            //Script bom para rotação, mas ruim para pivot
            transform.position = Vector3.zero;
            transform.rotation = Quaternion.Euler(0, -90, 0);
            World.Rotate(_orbitSpeed.x, _orbitSpeed.y);
            transform.RotateAround(Pivot.position, new Vector3(0, 1, 0), Mathf.Rad2Deg * World.Azimuth);
            transform.RotateAround(Pivot.position, new Vector3(1, 0, 0), Mathf.Rad2Deg * World.Elevation);
        } else if (!Mathf.Approximately(_orbitSpeed.sqrMagnitude, 0.0f)) {
            //Script ruim para rotação, mas bom para pivot
            World.Rotate(_orbitSpeed.x, _orbitSpeed.y);
            transform.RotateAround(Pivot.position, new Vector3(0, 1, 0), Mathf.Rad2Deg * _orbitSpeed.x);
            transform.RotateAround(Pivot.position, new Vector3(1, 0, 0), Mathf.Rad2Deg * _orbitSpeed.y);
        }

        _lastMousePos = Input.mousePosition;
    }

    public void InitPivot() {
        Pivot.position = Vector3.zero;
    }
}