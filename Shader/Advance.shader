Shader "Unlit/Advance"
{
    Properties
    {

        _FrontTex("FrontTex",2D)="white"{}
        _BackTex("BackTex",2D)="white"{}

    }
    SubShader       
    {
        Tags
        {
            "Queue"="Geometry"
            "RenderType"="Animal"
            "IgnoreProjector"="True"
            
        }
        // cull off
        Pass            //Pass渲染一次模型
        {
            CGPROGRAM
            #pragma vertex vert     //顶点着色器
            #pragma fragment frag   //片断着色器
            #pragma target 3.0

            sampler2D _FrontTex;
            sampler2D _BackTex;
            

            struct appdata          //应用阶段传入顶点着色器的数据
            {
                float4 vertex:POSITION;         //顶点
                float2 texcoord:TEXCOORD0;       //UV1    
            };
            struct v2f              //顶点着色器传递给片断着色器的结构体
            {
                float4 pos:SV_POSITION; //顶点着色器输出的屏幕裁剪空间下的顶点位置
                float2 uv:TEXCOORD;  //二维uv坐标
            };

            v2f vert(appdata v)      //几何阶段的顶点着色器
            { 
                v2f o;
                o.pos= UnityObjectToClipPos(v.vertex);        //四维向量vertex，为模型顶点的位置
                o.uv=v.texcoord;
                return o;                                   //模型坐标转换到裁剪坐标
            }                                               //POSITION顶点着色器，SV_POSITION像素着色器
            fixed4 frag(v2f i,float face:VFACE):SV_Target             //光栅化阶段的片断着色器    SV_TARGET输出到显示器的颜色值
            {
                fixed4 col;
                col=face>0? tex2D(_FrontTex,i.uv):tex2D(_BackTex,i.uv);
                return col;
            }
            ENDCG
        }
    }
}
