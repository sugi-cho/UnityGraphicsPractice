using UnityEngine;
using System.Collections;

public class SetMousePositionToMaterial : MonoBehaviour {
    public Material targetMat;
    public string propName = "_MPos";
    public float depth = 10f;
    // Use this for initialization
    void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        var mPos = Input.mousePosition;
        mPos.x /= Screen.width;
        mPos.y /= Screen.height;
        mPos.z = depth;
        targetMat.SetVector(propName, mPos);
    }
}
