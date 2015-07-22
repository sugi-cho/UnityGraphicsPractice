Shader "MassMeshDrawer/particle" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard vertex:vert addshadow

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
		#define TexSize 64

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float4 vColor;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		
		uniform float _Offset;
		uniform sampler2D 
			_MrTex0,
			_MrTex1;
		
		void vert(inout appdata_full v, out Input o){
			float id = v.texcoord1.x + _Offset;
			float2 uv = float2(frac(id/TexSize), id/TexSize/TexSize);
			float3 pos = tex2Dlod(_MrTex0,float4(uv,0,0));
			if(id >= TexSize*TexSize)
				v.vertex.xyz *= 0;
			v.vertex.xyz *= 0.5;
			v.vertex.xyz += pos;
			
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.vColor = float4(uv,id/TexSize/TexSize,1);
		}
		
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb*IN.vColor;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
