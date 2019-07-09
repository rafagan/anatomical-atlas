using System.Collections.Generic;
using UnityEngine;
using System.Collections;

public class LabelManager : MonoBehaviour {
    public List<GameObject> Labels;
    public int MaxLayers = 2; 
    public List<float> LayerDistances = new List<float>();

    private int _currentLayer;

	// Use this for initialization
	void Start () {
	    Labels = new List<GameObject>(GameObject.FindGameObjectsWithTag("label"));
        DisableLabels();

        LayerDistances.Add(60);
        LayerDistances.Add(0);
	}
	
	// Update is called once per frame
	void Update () {
	    var z = Camera.main.transform.position.z;

	    if (z > LayerDistances[0])
	        _currentLayer = 0;
        else if (z > LayerDistances[1])
            _currentLayer = 1;
	}

    public void ActivateLabels() {
        foreach (var label in Labels) {
            label.SetActive(true);
        }
    }

    public void DisableLabels() {
        foreach (var label in Labels) {
            label.SetActive(false);
        }
    }

    public void ActivateLabels(int layer) {
        foreach (var label in Labels) {
            label.SetActive(true);
        }
    }

    public void DisableLabels(int layer) {
        foreach (var label in Labels) {
            label.SetActive(false);
        }
    }
}
