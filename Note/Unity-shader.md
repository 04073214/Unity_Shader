# Unity Shader基础
---
## Unity Shader概述
* **Unity中渲染物体：** 创建一个材质；创建一个Unity Shader，把它赋给材质；把材质赋给要渲染的对象；在材质面板中调整Unity Shader的属性
* **Unity中的Shader：**
    * **Standard Surface Shader:** 包含标准光照模型的表面着色器模板
    * **Unlit Shader:** 不包含光照的基本顶点/片元着色器
    * **Image Effect Shader:** 屏幕后处理效果基本模板
    * **Compute Shader:** 一种特殊的Shader，利用GPU的并行性进行一些与常规渲染流水线无关的计算
---
## Unity Shader的结构
### 名字
**`Shader "Custom/Myshader"`:** 设置Unity Shader在材质面板中的位置，`Shader->Custom->Myshader`
### Properties
* Properties包含了一系列属性，这些属性将会出现在材质面板中
  ```java
    Properties{
        Name {"display name",PropertyType}= DefaultValue
        Name {"display name",PropertyType}= DefaultValue
        //更多属性
    }
    ```
* Name：在Shader中的名字，通常以下划线开始
* display name：在材质面板上的名字
* PropertyType：属性类型
* DefaultValue：属性默认值
<center><img src="image/Unity-shader/propertyType.png"  width=500></img></center>

* 数字类型：`Int`、`Float`、`Range`，默认值为一个数字
* 颜色和向量类型：`Color`、`Vector`，默认值为一个四维向量
* 纹理类型：`2D`、`Cube`、`3D`，默认值为字符串加花括号，字符串为内置的纹理名称，花括号用于指定一些纹理属性
### SubShader
```java
SubShader{
    //标签，可选的
    [Tags]

    //状态，可选的
    [RenderSetup]

    Pass{

    }
    //Other Passes
}
```
* 每个Unity Shader文件可以包含多个SubShader语义块，Unity要加载时，扫描所有的SubShader语义块，选择第一个能在目标平台上运行的SubShader。如果都不支持，则使用Fallback语义指定的Unity Shader
* 每个Pass定义了一次完整的渲染流程，状态和标签也可以在Pass中声明，但两者使用的标签是不一样的。在SubShader进行的设置会用于所有Pass
* 状态设置：
<center><img src="image/Unity-shader/rendersetup.png"  width=500></img></center>

* SubShader的标签：怎样以及何时渲染这个对象
  ```java
  Tags { "TagName1"="Value1" "TagName2"="Value2"}
  ```
<center><img src="image/Unity-shader/subshadertags.png"  width=500></img></center>

* Pass语义块
```java
Pass{
    [Name]
    [Tags]
    [RenderSetup]
    //Other code
}
```
* 名称：`Name "MyPassName"`，通过名称，可以使用UsePass命令来使用其他Unity Shader中的Pass，如`UsePass "Myshader/MYPASSNAME"`，Unity内部会把所有Pass名称转换成大写字母，因此使用UsePass命令必须使用大写形式的名字
* Pass中的标签：怎样渲染物体
<center><img src="image/Unity-shader/passtags.png"  width=500></img></center>

### Fallback
* 所有SubShader都不能运行时的备选Shader
    ```java
    Fallback "name"
    ```
* 可以关闭Fallback功能：`Fallback Off`
---
## Unity Shader的形式
### 表面着色器（Surface Shader）
* 表面着色器是Unity自己创造的一种着色器代码类型，是Unity对顶点/片元着色器的更高一层抽象，给定一个表面着色器，Unity会把它转换为对应的顶点/片元着色器
```C
Shader "Custom/Simple Surface Shader"{
    SubShader {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input{
            float4 color : COLOR;
        };
        void surf(Input IN,inout SurfaceOutput o){
            o.Albedo = 1;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
```
* 表面着色器被定义在SubShader语义块中的CGPROGRAM和ENDCG之间，不需要开发者关心使用多少个Pass、每个Pass如何渲染
### 顶点/片元着色器（Vertex/Fragment Shader）
```C
Shader "Custom/Simple VertexFragment Shader"{
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float4 vert(float4 v : POSITION) : SV_POSITION {
                return mul (UNITY_MATRIX_MVP, v);
            }

            float4 frag() : SV_Target {
                return fixed4(1.0,0.0,0.0,1.0);
            }

            ENDCG
        }
    }
}
```
* 定义在Pass语义块内，更加复杂，灵活性更高
### 固定函数着色器（Fixed Function Shader）
```C
Shader "Tutorial/Basic" {
    Properties {
        _Color ("Main Color", Color) = (1,0.5,0.5,1)
    }
    SubShader {
        Pass {
            Material {
                Diffuse [_Color]
            }
            Lighting On
        }
    }
}
```
* 用于一些较旧的设备，不支持可编程管线着色器
---