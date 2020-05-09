Shader "Tutorial/Chapter 6/Diffuse Pixel-Level" 
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)   //材质的漫反射颜色
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}       //光照模式，定义该Pass在Unity的光照流水线中的角色

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"

            fixed4 _Diffuse;

            struct a2v
            {
                float4 vertex:POSITION;     
                float3 normal:NORMAL;       //顶点法线
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);//顶点坐标从模型空间转换到裁剪空间

                //顶点法线从模型空间转换到世界空间
                o.worldNormal=mul(v.normal,(float3x3)unity_WorldToObject);

                return o;

            }

            fixed4 frag(v2f i):SV_Target
            {
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;  //获取环境光

                fixed3 worldNormal=normalize(i.worldNormal);    //获取法线

                //世界坐标下该Pass处理的光源方向
                fixed3 worldLightDir=normalize(_WorldSpaceLightPos0.xyz);

                //漫反射光照
                fixed3 difuse=_LightColor0.rgb* _Diffuse.rgb*saturate(dot(worldNormal,worldLightDir));

                //环境光和漫反射光相加
                fixed3 color=ambient+difuse;

                return fixed4(color,1.0);
            }

            ENDCG
        }
    }
    Fallback "Diffuse"
}