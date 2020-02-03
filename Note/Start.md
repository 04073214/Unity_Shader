# 开始Unity Shader学习之旅
---
## 一个简单的顶点/片元着色器
```
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


v2f vert(a2v v):SV_POSITION
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
```
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/simpleshader.png"  width=500></img></center>

* 编译指令`#pragma vertex vert`和`#pragma fragment frag`指定了哪个函数包含顶点着色器的代码和哪个函数包含片元着色器的代码
* `_Color`是在Properties语义块中声明的属性，在CG代码中需再次声明才能使用
* `POSITION`，`NORMAL`，`TEXCOORD0`，`SV_POSITION`，`COLOR0`，`SV_Target`是CG/HLSL中的语义，指定了用哪些输入值填充到输入参数中以及输出的参数代表什么
* 结构体`a2v`包含了顶点着色器需要的模型数据，是从应用阶段传递到顶点着色器的数据
* 结构体`v2f`是从顶点着色器传递到片元着色器的数据
* `UnityObjectToClipPos(v.vertex)`相当于`mul(UNITY_MATRIX_MVP,v)`，把顶点坐标从模型空间转换到裁剪空间
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/properties.png"  width=500></img></center>

## Unity提供的内置文件和变量
* 内置的包含文件
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/include.png"  width=500></img></center>

* 常用的结构体
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/struct.png"  width=500></img></center>

* 常用的函数
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/function.png"  width=500></img></center>

## Unity提供的CG/HLSL语义
* 语义名称相同，出现位置不同，含义也不同
* 系统数值语义：以SV开头，在渲染流水线中有特殊的含义，如SV_POSITION用于顶点着色器的输出，表示裁剪空间中的顶点坐标
* 下面是从应用阶段传递模型数据给顶点着色器时常用的语义，虽然没有使用SV开头，但具有特殊含义
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/semantics1.png"  width=500></img></center>

* 下面是从顶点着色器阶段到片元着色器阶段的常用语义，除了SV_POSITION有特殊含义外，其他语义对变量的含义没有明确要求，可以存储任意值到这些语义描述变量中
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/semantics2.png"  width=500></img></center>

* 片元着色器输出时的常用语义
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/semantics3.png"  width=500></img></center>

## Shader整洁之道
* CG/HLSL中3种精度的数值类型
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/type.png"  width=500></img></center>

* Shader中运算需要的临时寄存器数目或指令数目超过当前可支持的数目时，可以通过指定更高等级的Shader Target来使用更多的临时寄存器和运算指令
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader4/target.png"  width=500></img></center>

---