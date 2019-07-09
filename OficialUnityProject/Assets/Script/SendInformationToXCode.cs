using System;
using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class SendInformationToXCode 
{
	/* Interface to native implementation */
	
	[DllImport ("__Internal")]
	private static extern void _BoneTouched (string nameOfBone, bool isFaded, bool isHidden);
	[DllImport ("__Internal")]
	private static extern void _BlackAreaClicked ();
	[DllImport ("__Internal")]
	private static extern void _BookMarkChanged (string index);

	public static void PassInformation(string nameOfBone, bool isFaded, bool isHidden)
	{
		if (Application.platform != RuntimePlatform.OSXEditor)
			_BoneTouched (nameOfBone, isFaded, isHidden);
	}

	public static void ClearSignal()
	{
		if (Application.platform != RuntimePlatform.OSXEditor)
			_BlackAreaClicked ();
	}

	public static void PassToBookMark(int index)
	{
		if (Application.platform != RuntimePlatform.OSXEditor)
		{
			string str = Convert.ToString(index);
			_BookMarkChanged(str);
		}
	}
}
