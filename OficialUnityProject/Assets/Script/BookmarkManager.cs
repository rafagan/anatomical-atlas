using System;
using System.Collections.Generic;
using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class Pivot {
    public Vector3 Position;

    public Pivot(Vector3 position) {
        Position = position;
    }
}

public class Bookmark {
    public Vector3 ObjPos, CamPos;
    public Quaternion ObjRot;
    public SphericalCoordinates World;
    public Pivot MyPivot;
	public int Index;

    public Bookmark(int index, Transform obj, Transform camera, SphericalCoordinates world, Pivot pivot) {
        ObjPos = obj.position;
        ObjRot = obj.rotation;
        CamPos = camera.position;
        World = world;
        MyPivot = pivot;
		Index = index;
    }
}

public class BookmarkManager : MonoBehaviour 
{
	public Dictionary<int,Bookmark> Bookmarks = new Dictionary<int,Bookmark>();
    private GameObject _skeleton;

    void Awake() {
        _skeleton = GameObject.Find("Skeleton");
    }

    public void AddBookmark(string index) 
	{
		int id;
		id = int.Parse (index);

        var mark = 
            new Bookmark(
				id,
                _skeleton.transform, 
                Camera.main.transform, 
                _skeleton.GetComponent<RotationBehavior>().World.Clone() as SphericalCoordinates, 
                new Pivot(GameObject.Find("Pivot").transform.position));
		Bookmarks.Add (id, mark);
    }

    public void SetBookmark(string index) 
	{
		int id;
		id = int.Parse (index);
        var reset = _skeleton.GetComponent<Reset>();

        Reset.IsReseting = true;
		var b = Bookmarks[id];
        reset.ResetTransform(b.ObjRot, b.World, b.CamPos, b.ObjPos, b.MyPivot);
    }

	public void RemoveBookmark(int index) {
		Bookmarks.Remove (index);
	}
}
