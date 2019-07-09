using UnityEngine;
using System.Collections;

public class tag : MonoBehaviour {

	// Use this for initialization
	void Start () {
	    AddTagRecursively(gameObject.transform,"bone");
	}

    void AddTagRecursively(Transform trans, string strTag) {
        trans.gameObject.tag = strTag;
        trans.gameObject.AddComponent<Bone>();
        if (trans.GetChildCount() <= 0) return;
        foreach (Transform t in trans)
            AddTagRecursively(t, strTag);
    }

	// Update is called once per frame
	void Update () {

	
	}
}
