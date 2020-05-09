
Shader "Tutorial/Chapter 6/BlinnPhong" 
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
                float3 worldPos:TEXCOORD0;
                float3 worldNormal:TEXCOORD1;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);   //顶点坐标从模型空间转换到裁剪空间
                o.worldNormal=UnityObjectToWorldNormal(v.normal);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;

                return o;

            }

            fixed4 frag(v2f i):SV_Target
            {
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;  //获取环境光

                fixed3 worldNormal=normalize(i.worldNormal);    //获取法线

                //世界坐标下该Pass处理的光源方向
                fixed3 worldLightDir=normalize(_WorldSpaceLightPos0.xyz);

                //漫反射光照
                fixed3 diffuse=_LightColor0.rgb* _Diffuse.rgb*saturate(dot(worldNormal,worldLightDir));

                fixed3 viewDir=normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);
                fixed3 halfDir=normalize(worldLightDir+viewDir);

                fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(worldNormal,halfDir)),_Gloss);

                return fixed4(ambient+diffuse+specular,1.0);
            }

            ENDCG
        }
    }
    Fallback "Specular"
}