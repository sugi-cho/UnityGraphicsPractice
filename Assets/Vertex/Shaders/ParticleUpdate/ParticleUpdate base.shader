Shader "Custom/ParticleUpdate/base" {
	SubShader {
		Tags { "RenderType"="Opaque" }
		ZTest Always
		ZWrite On
		Cull Back

		CGINCLUDE

		uniform sampler2D
			_MrTex0,
			_MrTex1;
			
		struct appdata
		{
			float4 vertex : POSITION;
		};

		struct v2f {
			float4 vertex : SV_POSITION;
			float2 uv : TEXCOORD0;
		};

		struct pOut{
			float4 position : COLOR0;
			float4 velocity : COLOR1;
		};


		v2f vert (appdata v)
		{
			v2f o;
			o.vertex = v.vertex;
			o.uv = (v.vertex.xy/v.vertex.w+1.0)*0.5;
			return o;
		}
		
		float3 firstPos(float2 uv){
			float3 pos = 0;
			return pos;
		}
		pOut frag_initialize(v2f i){
			float4
				position = float4(firstPos(i.uv),0),
				velocity = 0;
			
			pOut o;
			o.position = position;
			o.velocity = velocity;
			return o;
		}

		pOut frag_update (v2f i)
		{
			float4
				position = tex2D(_MrTex0, i.uv),
				velocity = tex2D(_MrTex1, i.uv);
			
			position += velocity;
			
			pOut o;
			o.position = position;
			o.velocity = velocity;
			return o;
		}
		ENDCG

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag_initialize
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag_update
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
	}
}