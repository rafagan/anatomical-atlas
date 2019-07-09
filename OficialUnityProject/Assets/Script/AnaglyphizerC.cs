using System;
using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Camera))]
[AddComponentMenu("Anaglyphizer/Anaglyph-izer Cs Version")]

public class AnaglyphizerC : MonoBehaviour
{
	private int width = Screen.width;
	private int height = Screen.height;

    private RenderTexture leftEyeRT;
    private RenderTexture rightEyeRT;
    private GameObject leftEye;
    private GameObject rightEye;
    public Material AnaglyphMat;

    internal float zvalue = 0.0f; // original: 1.0

    public bool enableKeys = true;
    public KeyCode downEyeDistance = KeyCode.O;
    public KeyCode upEyeDistance = KeyCode.P;
    public KeyCode downFocalDistance = KeyCode.K;
    public KeyCode upFocalDistance = KeyCode.L;

    public bool useProjectionMatrix = false;

	public float angleCamera = 0.0f;

    public class S3DV
    {
        internal static float EyeDistance = 0.0f;
        internal static float FocalDistance = 200.00f;
    };

    public void InitAnaglyphizer() {
        // Code Added by esimple adding Various render mode

        if (AnaglyphMat == null) {
            Debug.LogError("No Material Found Please Drag The material in the appropriate Field");
            this.enabled = false;
            return;
        }

        // end of code added by esimple

        S3DV.EyeDistance = 0.75f;

        leftEye = new GameObject("leftEye", typeof(Camera));
        rightEye = new GameObject("rightEye", typeof(Camera));

        leftEye.camera.CopyFrom(camera);
        rightEye.camera.CopyFrom(camera);

        // Code Added by esimple adding GUI LAYER to dynamic camera
        leftEye.AddComponent<GUILayer>();
        rightEye.AddComponent<GUILayer>();

        leftEyeRT = new RenderTexture(width, height, 24);
        rightEyeRT = new RenderTexture(width, height, 24);

        leftEye.camera.targetTexture = leftEyeRT;
        rightEye.camera.targetTexture = rightEyeRT;

        AnaglyphMat.SetTexture("_LeftTex", leftEyeRT);
        AnaglyphMat.SetTexture("_RightTex", rightEyeRT);

        leftEye.camera.depth = camera.depth - 2;
        rightEye.camera.depth = camera.depth - 1;

        leftEye.transform.position = transform.position + transform.TransformDirection(-S3DV.EyeDistance, 0f, 0f);
        rightEye.transform.position = transform.position + transform.TransformDirection(S3DV.EyeDistance, 0f, 0f);

        if (!useProjectionMatrix) {
            leftEye.transform.LookAt(transform.position + (transform.TransformDirection(Vector3.forward) * S3DV.FocalDistance));
            rightEye.transform.LookAt(transform.position + (transform.TransformDirection(Vector3.forward) * S3DV.FocalDistance));
        } else {
            leftEye.transform.rotation = transform.rotation;
            rightEye.transform.rotation = transform.rotation;

            leftEye.camera.projectionMatrix = projectionMatrix(true);
            rightEye.camera.projectionMatrix = projectionMatrix(false);
        }

        leftEye.transform.parent = transform;
        rightEye.transform.parent = transform;

        camera.cullingMask = 0;
        camera.backgroundColor = new Color(0f, 0f, 0f, 0f);
        camera.clearFlags = CameraClearFlags.Nothing;
    }

    void OnDestroy() {
        Destroy(leftEye);
        Destroy(rightEye);
    }

    void UpdateView()
    {
        leftEye.camera.depth = camera.depth - 2;
        rightEye.camera.depth = camera.depth - 1;

        leftEye.transform.position = transform.position + transform.TransformDirection(-S3DV.EyeDistance, 0f, 0f);
        rightEye.transform.position = transform.position + transform.TransformDirection(S3DV.EyeDistance, 0f, 0f);

        if (!useProjectionMatrix)
        {
            leftEye.transform.LookAt(transform.position + (transform.TransformDirection(Vector3.forward) * S3DV.FocalDistance));
            rightEye.transform.LookAt(transform.position + (transform.TransformDirection(Vector3.forward) * S3DV.FocalDistance));
        }
        else
        {
            leftEye.transform.rotation = transform.rotation;
            rightEye.transform.rotation = transform.rotation;

            leftEye.camera.projectionMatrix = projectionMatrix(true);
            rightEye.camera.projectionMatrix = projectionMatrix(false);
        }

        leftEye.transform.parent = transform;
        rightEye.transform.parent = transform;
    }

    void LateUpdate()
    {
        UpdateView();

        if (!enableKeys) return;

        const float eyeDistanceAdjust = 0.01f;
        if (Input.GetKeyDown(upEyeDistance))
        {
            S3DV.EyeDistance += eyeDistanceAdjust;
        }
        else if (Input.GetKeyDown(downEyeDistance))
        {
            S3DV.EyeDistance -= eyeDistanceAdjust;
        }

        const float focalDistanceAdjust = 0.5f;
        if (Input.GetKeyDown(upFocalDistance))
        {
            S3DV.FocalDistance += focalDistanceAdjust;
        }
        else if (Input.GetKeyDown(downFocalDistance))
        {
            S3DV.FocalDistance -= focalDistanceAdjust;
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture.active = destination;
        GL.PushMatrix();
        GL.LoadOrtho();
        for (var i = 0; i < AnaglyphMat.passCount; i++)
        {
            AnaglyphMat.SetPass(i);
            DrawQuad();
        }
        GL.PopMatrix();
    }

    private void DrawQuad()
    {
        GL.Begin(GL.QUADS);
        GL.TexCoord2(0.0f, 0.0f); GL.Vertex3(0.0f, 0.0f, zvalue);
        GL.TexCoord2(1.0f, 0.0f); GL.Vertex3(1.0f, 0.0f, zvalue);
        GL.TexCoord2(1.0f, 1.0f); GL.Vertex3(1.0f, 1.0f, zvalue);
        GL.TexCoord2(0.0f, 1.0f); GL.Vertex3(0.0f, 1.0f, zvalue);
        GL.End();
    }

    Matrix4x4 PerspectiveOffCenter(float left, float right, float bottom, float top, float near, float far)
    {
        var x = (2.0f * near) / (right - left);
        var y = (2.0f * near) / (top - bottom);
        var a = (right + left) / (right - left);
        var b = (top + bottom) / (top - bottom);
        var c = -(far + near) / (far - near);
        var d = -(2.0f * far * near) / (far - near);
        var e = -1.0f;

        var m = new Matrix4x4();
        m[0, 0] = x; m[0, 1] = 0f; m[0, 2] = a; m[0, 3] = 0f;
        m[1, 0] = 0f; m[1, 1] = y; m[1, 2] = b; m[1, 3] = 0f;
        m[2, 0] = 0f; m[2, 1] = 0f; m[2, 2] = c; m[2, 3] = d;
        m[3, 0] = 0f; m[3, 1] = 0f; m[3, 2] = e; m[3, 3] = 0f;
        return m;
    }

    Matrix4x4 projectionMatrix(bool isLeftEye)
    {
        float left;
        float right;
        float a;
        float b;
        float fov;

        fov = camera.fieldOfView / 180.0f * Mathf.PI;  // convert FOV to radians

        var aspect = camera.aspect;

        a = camera.nearClipPlane * Mathf.Tan(fov * 0.5f);
        b = camera.nearClipPlane / S3DV.FocalDistance;

        if (isLeftEye)      	// left camera
        {
            left = -aspect * a + (S3DV.EyeDistance) * b;
            right = aspect * a + (S3DV.EyeDistance) * b;
        }
        else         		// right camera
        {
            left = -aspect * a - (S3DV.EyeDistance) * b;
            right = aspect * a - (S3DV.EyeDistance) * b;
        }

        return PerspectiveOffCenter(left, right, -a, a, camera.nearClipPlane, camera.farClipPlane);

    }
}


