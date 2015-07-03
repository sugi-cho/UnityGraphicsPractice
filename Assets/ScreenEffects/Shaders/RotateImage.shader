Shader "Custom/RadialBlur" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Center ("center point", Vector) = (0.5,0.5,0,0)
		_Amount ("amount",Float) = 0.2
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#define PI 3.1415
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		half2 _Center;
		half _Amount;
		
		half2 getUvRotated(half2 uv, half2 center, half angle){
			angle *= PI*2.0;
			half2 d = _MainTex_TexelSize.xy;
			float s,c;
			sincos(angle,s,c);
			uv -= center;
			uv.x *= d.y/d.x;
			float2x2 rot = float2x2(
				c,-s,
				s, c
			);
			uv = mul(rot,uv);
			uv.x /= d.y/d.x;
			uv += center;
			return uv;
		}
		
		half4 frag(v2f_img i) : COLOR{
			half2 uv = getUvRotated(i.uv,_Center,_Amount*_Time.y);
			half4 c = tex2D(_MainTex, frac(uv));
			c = 2*c*c;
			return c;
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