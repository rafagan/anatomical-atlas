//using System;
//using System.Collections.Generic;
//using UnityEngine;
//using System.Collections;
//using System.Runtime.InteropServices;
//
//public class XCodeSlotManager 
//{
//
//	public void ParseAddBookmark(string index) 
//	{
//		int id;
//		id = int.Parse (index);
//	}
//	
//	public void SetBookmark(string index) 
//	{
//		int id;
//		id = int.Parse (index);
//		var reset = _skeleton.GetComponent<Reset>();
//		
//		Reset.IsReseting = true;
//		var b = Bookmarks[id];
//		reset.ResetTransform(b.ObjRot, b.World, b.CamPos, b.ObjPos, b.MyPivot);
//	}
//}
