using UnityEngine;
using System.Collections;

public class RotateCam : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        transform.RotateAround(Vector3.zero, Vector3.up, 5.0f * Time.deltaTime);
    }
}
