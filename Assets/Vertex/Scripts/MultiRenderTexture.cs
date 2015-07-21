using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class MultiRenderTexture : MonoBehaviour
{
    public int numOutputs = 2;
    public int texSize = 64;
    public Material initMat;
    public Material updateMat;
    public string propName = "_MrTex";
    RenderTexture[] outputTextures;
    [SerializeField]
    List<RenderTexture[]> rtsList;


    // Use this for initialization
    void Start()
    {
        rtsList = new List<RenderTexture[]>(numOutputs);
        for (var i = 0; i < numOutputs; i++)
        {
            var rts = new RenderTexture[2] {
                new RenderTexture(texSize, texSize, 0),
                new RenderTexture(texSize, texSize, 0)
            };
        }
    }

    void OnDestroy()
    {
        foreach (var rts in rtsList)
        {
            for (var i = 0; i < 2; i++)
            {
                if (rts[i] != null)
                {
                    rts[i].Release();
                    Destroy(rts[i]);
                }
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        Render();
        SetProps();
    }

    void Render(int pass = 0)
    {
        var cBuffers = rtsList.Select(b => b[0].colorBuffer).ToArray();
        var dBuffer = rtsList[0][0].depthBuffer;
        Graphics.SetRenderTarget(cBuffers, dBuffer);
        DrawQuad(updateMat, pass);
        SwapRts();
        Graphics.SetRenderTarget(null);
    }
    void SwapRts()
    {
        foreach (var rts in rtsList)
        {
            var tmp = rts[0];
            rts[0] = rts[1];
            rts[1] = tmp;
        }
    }
    void DrawQuad(Material mat, int pass = 0)
    {
        GL.PushMatrix();
        mat.SetPass(pass);
        GL.Begin(GL.QUADS);
        GL.Vertex3(-1.0f, -1.0f, 1.0f);
        GL.Vertex3(1.0f, -1.0f, 1.0f);
        GL.Vertex3(1.0f, 1.0f, 1.0f);
        GL.Vertex3(-1.0f, 1.0f, 1.0f);

        GL.Vertex3(-1.0f, 1.0f, 1.0f);
        GL.Vertex3(1.0f, 1.0f, 1.0f);
        GL.Vertex3(1.0f, -1.0f, 1.0f);
        GL.Vertex3(-1.0f, -1.0f, 1.0f);
        GL.End();
        GL.PopMatrix();
    }

    void SetProps()
    {
        for (var i = 0; i < rtsList.Count; i++)
        {
            var pName = propName + i.ToString();
            Shader.SetGlobalTexture(pName, rtsList[i][0]);
        }
    }
}
