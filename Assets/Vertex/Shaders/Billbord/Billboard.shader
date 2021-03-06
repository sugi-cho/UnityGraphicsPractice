﻿Shader "Custom/Billboard" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("texture", 2D) = "white" {}
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
		};
 
		v2f vert (appdata_full v)
		{
			float3 center = v.vertex.xyz;
			center.xy -= v.texcoord.xy -0.5;
			v.vertex.xyz = center; 
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MV, float4(v.vertex));
			o.pos.xy += v.texcoord.xy-0.5;
			o.pos = mul(UNITY_MATRIX_P, o.pos);
			
			o.color = v.color;
			o.texcoord = v.texcoord;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			return i.color * _Color * tex2D(_MainTex, i.texcoord);
		}
	ENDCG
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaTest Greater .01
		Cull Off Lighting Off ZWrite Off
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}