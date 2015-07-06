Shader "Custom/RadialBlur" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Center ("center point", Vector) = (0.5,0.5,0,0)
		_Rotate ("rotate", Float) = 0.1
		_Zoom ("zoom",Float) = 0.1
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#define PI 3.1415
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		half2 _Center;
		half _Rotate, _Zoom;
		
		//ガウシアン曲線 built-in ブラーエフェクトのShaderより
		static const half curve[7] = { 0.0205, 0.0855, 0.232, 0.324, 0.232, 0.0855, 0.0205 };
			
		half2 getUvRotated(half2 uv, half2 center, half angle){
			//angleが1で、１回転するようにする。
			angle *= PI*2.0;
			half2 d = _MainTex_TexelSize.xy;
			
			//いったん、変形の中心座標を(0,0,0)に持ってきてから計算する。
			uv -= center;
			//アスペクト比の違いに対応できるよう調整
			uv.x *= d.y/d.x;
			
			float s,c;
			//s = sin(angle), c = cos(angle)が入る関数
			sincos(angle,s,c);
			
			//２次元の回転行列求め、mul()で計算する
			float2x2 rot = float2x2(
				c,-s,
				s, c
			);
			uv = mul(rot,uv);
			
			//アスペクト比を元に戻す
			uv.x /= d.y/d.x;
			//中心の位置を元に戻す
			uv += center;
			return uv;
		}
		half2 getUvScaled(half2 uv, half2 center, half scale){
			half2 d = _MainTex_TexelSize.xy;
			uv -= center;
			uv.x *= d.y/d.x;
			
			//(0,0,0)を中心にuvをスケール（拡大）
			uv *= 1.0+scale;
			
			uv.x /= d.y/d.x;
			uv += center;
			return uv;
		}
		
		half4 frag_spin(v2f_img i) : COLOR{
			float angle = -3.0*_Rotate;
			half4 c = 0;
			
			for(int l=0; l<7; l++){
				half2 uv = getUvRotated(i.uv, _Center, angle);
				c += tex2D(_MainTex, frac(uv)) * curve[l];
				angle += _Rotate;
			}
			
			return c;
		}
		half4 frag_zoom(v2f_img i) : COLOR{
			half scale = -3.0*_Zoom;
			half4 c = 0;
			for(int l=0; l<7; l++){
				half2 uv = getUvScaled(i.uv, _Center, scale);
				c += tex2D(_MainTex, frac(uv)) * curve[l];
				scale += _Zoom;
			}
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
			#pragma fragment frag_spin
			ENDCG
		}
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag_zoom
			ENDCG
		}
	} 
}