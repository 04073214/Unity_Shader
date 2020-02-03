Shader "Tutorial/Chapter 5/Simple Shader" 
{
    Properties
    {
        _Color ("Color Tint",Color)=(1.0,1.0,1.0,1.0)
    }
    SubShader 
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            fixed4 _Color;

            //使用一个结构体来定义顶点着色器的输入
            struct a2v{
                float4 vertex:POSITION;     //模型空间的顶点坐标
                float3 normal:NORMAL;       //模型空间的法线方向
                float4 texcoord:TEXCOORD0;   //模型的第一套纹理坐标
            };

            struct v2f{
                float4 pos:SV_POSITION;     //裁剪空间的顶点坐标
                fixed3 color:COLOR0;        //颜色信息
            };


            v2f vert(a2v v):POSITION
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.color=_Color;
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                return fixed4(i.color,1.0);
            }

            ENDCG
        }
    }
}