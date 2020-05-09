// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Tutorial/Chapter 6/Specular Vertex-Level" 
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)     //材质的漫反射颜色
        _Specular("Specular",Color)=(1,1,1,1)   //材质的高光反射颜色
        _Gloss("Gloss",Range(8.0,256))=20       //高光区域的大小
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
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex:POSITION;     
                float3 normal:NORMAL;       //顶点法线
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                float3 color:COLOR;     //光照颜色
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);   //顶点坐标从模型空间转换到裁剪空间

                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;   //获取环境光

                //顶点法线从模型空间转换到世界空间
                fixed3 worldNormal=normalize(mul(v.normal,(float3x3)unity_WorldToObject));

                //世界坐标下该Pass处理的光源方向
                fixed3 worldLightDir=normalize(_WorldSpaceLightPos0.xyz); 

                //_LightColor0为该Pass处理的光源的颜色，diffuse为漫反射光照
                fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal,worldLightDir));

                //入射光线关于表面法线的反射方向
                fixed3 reflectDir=normalize(reflect(-worldLightDir,worldNormal));

                //世界空间下的视角方向
                fixed3 viewDir=normalize(_WorldSpaceCameraPos.xyz-mul(unity_ObjectToWorld,v.vertex).xyz);

                //高光反射光照
                fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectDir,viewDir)),_Gloss);

                //高光反射光、环境光和漫反射光相加
                o.color=ambient+diffuse+specular;

                return o;

            }

            fixed4 frag(v2f i):SV_Target
            {
                return fixed4(i.color,1.0);
            }

            ENDCG
        }
    }
    Fallback "Specular"
}