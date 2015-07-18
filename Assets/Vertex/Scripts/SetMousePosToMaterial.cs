using UnityEngine;
using System.Collections;

public class SetMousePosToMaterial : MonoBehaviour
{
    public Material targetMat;
    public string propName = "_Pos";
    public float distance = 10f;
    Camera camera;
    // Use this for initialization
    void Start()
    {
        camera = GetComponent<Camera>();
    }

    // Update is called once per frame
    void Update()
    {
        var pos = Input.mousePosition;
        pos.z = distance;
        pos = camera.ScreenToWorldPoint(pos);
        targetMat.SetVector(propName, pos);
    }
}
