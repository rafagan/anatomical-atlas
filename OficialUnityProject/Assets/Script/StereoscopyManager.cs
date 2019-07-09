using System;
using UnityEngine;
using System.Collections;

public class StereoscopyManager : MonoBehaviour {
    public Material StereoscopyMaterial;

    void TriggerEnable() {
        var c = camera.gameObject.AddComponent<AnaglyphizerC>();
        c.AnaglyphMat = StereoscopyMaterial;
        c.InitAnaglyphizer();
    }

    void TriggerDisable() {
        camera.clearFlags = CameraClearFlags.Skybox;
        camera.cullingMask = Convert.ToInt32("111111", 2);
        Destroy(camera.gameObject.GetComponent <AnaglyphizerC>());
    }
}
