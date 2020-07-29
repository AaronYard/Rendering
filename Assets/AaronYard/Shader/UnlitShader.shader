/*
Unlit Shader，简单来说，就是直接采用漫反射纹理，不考虑场景中的任何灯光效果。
使用无灯光着色器的话，也就不能使用任何镜面或者法线效果了。
Unlit系的Shader基本原理和其他Shader无异，但是计算量更小，更快速，更高效。
*/
Shader "模板/UnlitShader"
{
	//------------------------------------【属性值】------------------------------------
	Properties
	{
		//主纹理
		_MainTex ("Texture", 2D) = "white" {}
	}
	//------------------------------------【唯一的子着色器】------------------------------------
	SubShader
	{
		//渲染类型设置：不透明
		Tags { "RenderType"="Opaque" }
		//细节层次设为：100
		LOD 100
		//--------------------------------唯一的通道-------------------------------
		Pass
		{
			//===========开启CG着色器语言编写模块===========
			CGPROGRAM
			//编译指令:告知编译器顶点和片段着色函数的名称
			#pragma vertex vert
			#pragma fragment frag
			//着色器变体快捷编译指令：雾效。编译出几个不同的Shader变体来处理不同类型的雾效(关闭/线性/指数/二阶指数)
			#pragma multi_compile_fog
			//包含头文件
			#include "UnityCG.cginc"
			//顶点着色器输入结构
			struct appdata
			{
				float4 vertex : POSITION;//顶点位置
				float2 uv : TEXCOORD0;//纹理坐标
			};
			//顶点着色器输出结构
			struct v2f
			{
				float2 uv : TEXCOORD0;//纹理坐标
				UNITY_FOG_COORDS(1)//雾数据
				float4 vertex : SV_POSITION;//像素位置
			};
			//变量声明
			sampler2D _MainTex;
			float4 _MainTex_ST;
			//--------------------------------【顶点着色函数】-----------------------------  
			//输入：顶点输入结构体  
			//输出：顶点输出结构体  
			//---------------------------------------------------------------------------------
			v2f vert (appdata v)
			{
				//【1】实例化一个输入结构体
				v2f o;
				//【2】填充此输出结构  
				//输出的顶点位置（像素位置）为模型视图投影矩阵乘以顶点位置,也就是将三维空间中的坐标投影到了二维窗口
				o.vertex = UnityObjectToClipPos(v.vertex);
				//【3】用UnityCG.cginc头文件中内置定义的宏,根据uv坐标来计算真正的纹理上对应的位置（按比例进行二维变换）
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//【4】用UnityCG.cginc头文件中内置定义的宏处理雾效，从顶点着色器中输出雾效数据
				UNITY_TRANSFER_FOG(o,o.vertex);
				//【5】返回此输出结构对象
				return o;
			}
			//--------------------------------【片段着色函数】-----------------------------  
			//输入：顶点输出结构体  
			//输出：float4型的像素颜色值  
			//---------------------------------------------------------------------------------
			fixed4 frag (v2f i) : SV_Target
			{
				//【1】采样主纹理在对应坐标下的颜色值
				fixed4 col = tex2D(_MainTex, i.uv);
				//【2】用UnityCG.cginc头文件中内置定义的宏启用雾效
				UNITY_APPLY_FOG(i.fogCoord, col);
				//【3】返回最终的颜色值
				return col;
			}
			//===========结束CG着色器语言编写模块===========
			ENDCG
		}
	}
}
/*
注①：TRANSFORM_TEX宏可以根据uv坐标来计算真正的纹理上对应的位置（按比例进行二维变换），
组合上上文中定义的float4 _MainTex_ST，便可以计算真正的纹理上对应的位置。
*/

/*
注②：UNITY_APPLY_FOG宏的作用是从顶点着色器中输出雾效数据，将第二个参数中的颜色值作为雾效的颜色值，
且在正向附加渲染通道（forward-additive pass）中，自动设置纯黑色（fixed4(0,0,0,0)）的雾效。
其在定义中借助了UNITY_APPLY_FOG_COLOR宏，而我们也可以使用UNITY_APPLY_FOG_COLOR来指定特定颜色的雾效。
*/