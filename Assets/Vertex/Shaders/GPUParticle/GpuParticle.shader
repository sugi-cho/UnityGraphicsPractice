Shader "Custom/GPU Particle" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("texture", 2D) = "white" {}
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		#define TexSize 64
		
		sampler2D _MainTex;
		fixed4 _Color;
		uniform sampler2D 
			_MrTex0,
			_MrTex1;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
		};
 
		v2f vert (appdata_full v)
		{
			float2 uv = float2(frac(v.texcoord1.x/TexSize), v.texcoord1.x/TexSize/TexSize);
			float3 pos = tex2Dlod(_MrTex0,float4(uv,0,1));
			
			float3 center = v.vertex.xyz;
			center.xy -= v.texcoord.xy -0.5;
			center += pos;
			v.vertex.xyz = center;
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MV, v.vertex);
			o.pos.xy += v.texcoord.xy-0.5;
			o.pos = mul(UNITY_MATRIX_P, o.pos);
			
			o.color = v.color;
			o.texcoord = v.texcoord;
			
			if(1.0 <= uv.y)
				o.pos = 0;
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