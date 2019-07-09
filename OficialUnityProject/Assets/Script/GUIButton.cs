//using System.Collections.Generic;
//using UnityEngine;
//using System.Collections;
//
//public class GUIButton : MonoBehaviour {
//    private BookmarkManager _bkManager;
//
//	private static int idGen = 0;
//
//    private int _selGridPrevious;
//    private int _selGridInt;
//
//    void Awake() {
//        _bkManager = GameObject.Find("AppManager").GetComponent<BookmarkManager>();
//    }
//
//    void OnGUI() {
//        GUI.backgroundColor = Color.green;
//
//        var pos = new Vector2(100, 0);
//        if (GUI.Button(new Rect(10 + pos.x, 10 + pos.y, 70 + pos.x, 30 + pos.y), "Insert")) {
//            //_bkManager.AddBookmark(idGen++);
//        }
//
//        var selStrings = new List<string>();
//        foreach (var bk in _bkManager.Bookmarks) {
//            selStrings.Add("bookmark");
//        }
//
//        _selGridInt = GUILayout.SelectionGrid(_selGridInt, selStrings.ToArray(), 1);
//
//        if (_selGridPrevious != _selGridInt) {
//            _selGridPrevious = _selGridInt;
//            //_bkManager.SetBookmark(_selGridInt);
//        }
//    }
//}
