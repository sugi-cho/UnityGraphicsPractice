﻿Shader "Custom/ImageEffectBase" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
			//メインテクスチャをそのまま出力
			return tex2D(_MainTex, i.uv);
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