Shader "Unlit/MyFirstShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
	}

		SubShader
	{
		Pass
		{
			CGPROGRAM
			//定义顶点着色器为vert
			#pragma vertex vert
			//定义片断着色器为frag
			#pragma fragment frag

			fixed4 _Color;
			//几何阶段中的顶点着色器
			float4 vert(float4 vertex : POSITION) : SV_POSITION
			{
				return UnityObjectToClipPos(vertex);
			}

			//光栅化阶段中的片段着色器
			float4 frag() : SV_Target
			{
				return _Color;
			}
			ENDCG
		}
	}
}