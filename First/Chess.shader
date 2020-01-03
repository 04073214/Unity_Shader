Shader "Unlit/First"        //Shader路径，加Hidden/隐藏
{
    Properties      //[Attribute]_Name ("Display Name",Type) = Default Value
    {
        // [Header(Texture)]_3DTexture("3DTexture",3D)=""{}
        // [NoScaleOffset]_MainTex ("Texture", 2D) = "gray" {}   
        // _Cube("Cube",Cube)=""{}
        [HDR]_Color("Color",Color)=(1,1,1,1)
        // [IntRange]_Int("Int",Range(0,1))=1
        // _Float("Float",Float)=0.5
        // [PowerSlider(3)]_Range("Range",Range(0,1))=0.5
        // [Toggle]_Toggle("Toggle",Range(0,1))=0
        // [Enum(UnityEngine.Rendering.CullMode)]_Enum("Enum",Float)=1
        // _Vector("Vector",Vector)=(0,0,0,0)
    }
    SubShader       
    {
        Pass            //Pass渲染一次模型
        {
            CGPROGRAM
            #pragma vertex vert     //顶点着色器
            #pragma fragment frag   //片断着色器

            fixed4 _Color;      //变量类型float/half/fixed 高/中/低精度 32/16/11位
                                //获取分量 _Color.rbga或_Color.xy

            struct appdata          //应用程序阶段的结构体
            {
                float4 vertex:POSITION;         //变量名:语义
                float2 uv:TEXCOORD;
            };
            struct v2f              //顶点着色器传递给片断着色器的结构体
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD;  //二维uv坐标
            };

            v2f vert(appdata v)      //几何阶段的顶点着色器
            { 
                v2f o;
                o.pos= UnityObjectToClipPos(v.vertex);        //四维向量vertex，为模型顶点的位置
                o.uv=v.uv;
                return o;                                   //模型坐标转换到裁剪坐标
            }                                               //POSITION顶点着色器，SV_POSITION像素着色器

            fixed checker(float2 uv)
            {
                float2 repeatUV=uv*10;
                float2 c=floor(repeatUV) /2;
                float checker=frac(c.x+c.y)*2;
                return checker;
            }

            fixed4 frag(v2f i):SV_Target             //光栅化阶段的片断着色器    SV_TARGET输出到显示器的颜色值
            {
                // return _Color;
                // return fixed4(i.uv,0,1);
                fixed col=checker(i.uv);
                return col;
            }
            ENDCG
        }
    }
}
