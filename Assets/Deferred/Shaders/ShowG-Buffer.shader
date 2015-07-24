Shader "Custom/ShowG-Buffer" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		uniform sampler2D
			_CameraGBufferTexture0,
			_CameraGBufferTexture1,
			_CameraGBufferTexture2,
			_CameraGBufferTexture3;
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
			float2 uv = frac(i.uv*2);
			half4
				tex = 0,
				t0 = tex2D(_CameraGBufferTexture0,uv),
				t1 = tex2D(_CameraGBufferTexture1,uv),
				t2 = tex2D(_CameraGBufferTexture2,uv),
				t3 = tex2D(_CameraGBufferTexture3,uv);
			if(i.uv.x < 0.5){
				if(i.uv.y<0.5){
					tex = t0;
				}
				else{
					tex = t1;
				}
			}
			else{
				if(i.uv.y<0.5){
					tex = t2;
				}
				else{
					tex = t3;
				}
			}
			return tex;
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }

		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}