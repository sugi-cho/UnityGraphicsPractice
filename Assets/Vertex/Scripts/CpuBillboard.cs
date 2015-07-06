using UnityEngine;
using System.Collections;

public class CpuBillboard : MonoBehaviour {
    public Transform target;
    public float rotation;
    // Use this for initialization
    void Start () {
        if (target == null)
            target = Camera.main.transform;
    }

    // Update is called once per frame
    void Update()
    {
        transform.LookAt(target.transform);
    }
}
