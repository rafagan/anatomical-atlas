using System;
using UnityEngine;

public class SphericalCoordinates : ICloneable
{
    //Toda coordenada esférica possui:
    //Raio: Distância do centro da esfera
    //Azimute: É o mesmo do ângulo das coordenadas polares. O intervalo é [0, 360). Equivale ao ângulo em relação a x.
    //Eixo polar: É o mesmo que elevação. O intervalo é [0, 180). Equivale ao ângulo em relação ao zênite.

    public float Radius
    {
        get { return _radius; }
        private set { _radius = Mathf.Clamp(value, _minRadius, _maxRadius); }
    }
    public float Azimuth
    {
        get { return _polar; }
        private set
        {
            _polar = LoopAzimuth ? Mathf.Repeat(value, _maxAzimuth - _minAzimuth)
                               : Mathf.Clamp(value, _minAzimuth, _maxAzimuth);
        }
    }
    public float Elevation
    {
        get { return _elevation; }
        private set
        {
            _elevation = LoopElevation ? Mathf.Repeat(value, _maxElevation - _minElevation)
                                       : Mathf.Clamp(value, _minElevation, _maxElevation);
        }
    }

    // Determine what happen when a limit is reached, repeat or clamp.
    public bool LoopAzimuth = true, LoopElevation = false;

    private float _radius, _polar, _elevation;
    private readonly float _minRadius, _maxRadius, _minAzimuth, _maxAzimuth, _minElevation, _maxElevation;

    public SphericalCoordinates() { }
    public SphericalCoordinates(float radius, float azimuth, float elevation,
        float minRadius = 1f, float maxRadius = 20f,
        float minAzimuth = 0f, float maxAzimuth = (Mathf.PI*2f),
        float minElevation = 0f, float maxElevation = Mathf.PI)
    {
        _minRadius = minRadius;
        _maxRadius = maxRadius;
        _minAzimuth = minAzimuth;
        _maxAzimuth = maxAzimuth;
        _minElevation = minElevation;
        _maxElevation = maxElevation;

        SetRadius(radius);
        SetRotation(azimuth, elevation);
    }

    public SphericalCoordinates(Transform T,
        float minRadius = 1f, float maxRadius = 20f,
        float minAzimuth = 0f, float maxAzimuth = (Mathf.PI*2f),
        float minElevation = 0f, float maxElevation = (Mathf.PI / 3f)) :
        this(T.position, minRadius, maxRadius, minAzimuth, maxAzimuth, minElevation, maxElevation)
    { }

    public SphericalCoordinates(Vector3 cartesianCoordinate,
        float minRadius = 1f, float maxRadius = 20f,
        float minAzimuth = 0f, float maxAzimuth = (Mathf.PI*2f),
        float minElevation = 0f, float maxElevation = (Mathf.PI / 3f))
    {
        _minRadius = minRadius;
        _maxRadius = maxRadius;
        _minAzimuth = minAzimuth;
        _maxAzimuth = maxAzimuth;
        _minElevation = minElevation;
        _maxElevation = maxElevation;

        FromCartesian(cartesianCoordinate);
    }

    public Vector3 ToCartesian
    {
        get
        {
            var tmp = Radius * Mathf.Cos(Elevation);
            return new Vector3(tmp * Mathf.Cos(Azimuth), Radius * Mathf.Sin(Elevation), tmp * Mathf.Sin(Azimuth));
        }
    }

    public SphericalCoordinates FromCartesian(Vector3 cartesianCoordinate)
    {   
        Radius = cartesianCoordinate.magnitude;
        Elevation = Mathf.Asin(cartesianCoordinate.y / Radius);

        if (Mathf.Approximately(cartesianCoordinate.x, 0f)) cartesianCoordinate.x = Mathf.Epsilon;
        Azimuth = Mathf.Atan(cartesianCoordinate.z / cartesianCoordinate.x);
        if (cartesianCoordinate.x < 0f) Azimuth += Mathf.PI;

        return this;
    }

    public SphericalCoordinates RotatePolarAngle(float x) { return Rotate(x, 0f); }
    public SphericalCoordinates RotateElevationAngle(float x) { return Rotate(0f, x); }
    public SphericalCoordinates Rotate(float newPolar, float newElevation) { return SetRotation(Azimuth + newPolar, Elevation + newElevation); }
    public SphericalCoordinates SetPolarAngle(float x) { return SetRotation(x, Elevation); }
    public SphericalCoordinates SetElevationAngle(float x) { return SetRotation(x, Elevation); }
    public SphericalCoordinates SetRotation(float newPolar, float newElevation)
    {
        Azimuth = newPolar;
        Elevation = newElevation;

        return this;
    }

    public SphericalCoordinates TranslateRadius(float x) { return SetRadius(Radius + x); }
    public SphericalCoordinates SetRadius(float rad)
    {
        Radius = rad;
        return this;
    }

    public override string ToString()
    {
        return "[Radius] " + Radius + ". [Azimuth] " + Azimuth + ". [Elevation] " + Elevation + ".";
    }

    public object Clone() {
        return MemberwiseClone();
    }
}