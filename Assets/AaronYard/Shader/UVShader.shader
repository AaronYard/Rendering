Shader "Unlit/UVShader"
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
			//应用程序阶段的结构体
			struct appdata
			{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD;
			};
			//顶点着色器传递给片元着色器的结构体
			struct v2f
			{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD;
			};
			//几何阶段中的顶点着色器
			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			//自定义函数
			fixed checker(float2 uv)
			{
				float2 repeatUV = uv * 10;
				float2 c = floor(repeatUV) / 2;
				//frac 取小数部分
				float checker = frac(c.x + c.y) * 2; 
				return checker;
			}

			//光栅化阶段中的片段着色器
			fixed4 frag(v2f i) : SV_Target
			{
				//调用函数得到近似值
				fixed col = checker(i.uv);
				return col;
			}
			ENDCG
}
	}
}