using UnityEngine;
using System.Collections;

public class ExampleClass : MonoBehaviour {
    public Matrix4x4 originalProjection;
    Camera camera;
    
    void Start() {
    	camera = GetComponent<Camera>();
    }
    
    void Update() {
        Matrix4x4 p = originalProjection;
        p.m01 += Mathf.Sin(Time.time * 1.2F) * 0.1F;
        p.m10 += Mathf.Sin(Time.time * 1.5F) * 0.1F;
        camera.projectionMatrix = p;
    }
}