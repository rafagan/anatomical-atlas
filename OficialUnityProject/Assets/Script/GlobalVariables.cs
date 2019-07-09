using UnityEngine;
using System.Collections;

public class GlobalVariables : MonoBehaviour {
    public static float ZoomNearLimit = -80;
    public static float ZoomFarLimit = 80;

    public static float ZoomSpeedScroll = 50f;
    public static float ZoomSpeedPinch = 1.5f;
    public static float ZoomSpeedDClick = 5;
    public static float ZoomThreshold = 10;

    public static float RotationSpeed = 0.12f;
    public static float TranslationSpeed = 8f;

    public static float ResetRotationSpeed = 5f;
    public static float ResetTranslationSpeed = 5f;
}
