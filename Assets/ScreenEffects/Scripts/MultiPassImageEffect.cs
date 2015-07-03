using UnityEngine;
using System.Collections;

public class MultiPassImageEffect : MonoBehaviour
{
    public Material mat;
    RenderTexture[] rts;
    void Start()
    {
        rts = new RenderTexture[2];
        for (var i = 0; i < rts.Length; i++)
            rts[i] = new RenderTexture(Screen.width, Screen.height, 0);
    }
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, rts[0]);
        for (var i = 0; i < mat.passCount; i++)
        {
            Graphics.Blit(rts[0], rts[1], mat, i);
            var tmp = rts[0];
            rts[0] = rts[1];
            rts[1] = tmp;
        }
        Graphics.Blit(rts[0], dest);
    }
}
