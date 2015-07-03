using UnityEngine;
using System.Collections;

public class ShowWebcamTexture : MonoBehaviour
{
    public int width = 1280;
    public int height = 720;

    WebCamTexture webcamTex;
    // Use this for initialization
    void Start () {
        webcamTex = new WebCamTexture(width, height);
        webcamTex.Play();
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
		//WebcamTextureをdestinationのテクスチャにいれると、カメラのテクスチャがそのままスクリーンに表示される
        Graphics.Blit(webcamTex, destination);
    }
}
