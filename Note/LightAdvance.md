# 高级光照模型
---
## 全局光照
* 全局光照，指的就是模拟光线是如何在场景中传播的，不仅考虑直接光照的结果，还会计算光线被不同的物体表面反射而产生的间接光照
* 在使用基于物理的着色技术时，当渲染表面上一点时，我们需要计算该点的半球范围内所有会反射到观察方向的入射方向的光照结果，这些入射光线中就包含了直接光照和间接光照
* Rendering Equation：
$$L_{o}(x,w_{o})=L_{e}(x,w_{o})+\int_{\Omega}f_{r}(x,w_{i},w_{o})L_{i}(x,w_{i})(n\cdot w_{i})dw_{i} $$
$x$：入射点
$L_{o}(x,w_{o})$：从物体表面$x$点，沿方向$w_{o}$反射的光强
$L_{e}(x,w_{o})$：从物体表面$x$点，沿方向$w_{o}$发射出去的光强，该值仅对自发光体有效
$f_{r}(x,w_{i},w_{o})$：入射光线方向为$w_{i}$，照射到点$x$上，然后从$w_{o}$方向反射出去的BRDF值
$L_{i}(x,w_{i})$：入射光线方向为$w_{i}$，照射到点$x$上入射光强
$n$：点$x$处的法向量
* 对入射方向进行积分（因为光线入射的方向是四面八方的，积分的意义是对每个方向进行一遍计算后进行相加），计算的结果就是“从观察方向上看到的辐射率”
* 该公式基于物理光学，对观察方向上辐射率的进行了本质上的量化，上一章的漫反射光照模型和Phong高光模型，其实是公式在单一光源，特定 BRDF 下的推导
* 对于单个点光源照射到不会自发光的物体上，公式可以简化为：
$$L_{o}(x,w_{o})=f_{r}(x,w_{i},w_{o})L_{i}(x,w_{i})(n\cdot w_{i})$$
* 通常会将该公式分解为漫反射表达式和高光反射表达式之和。对于漫反射表面，BRDF 可以忽略不计，因为它总是返回某个恒定值，所以公式可以写成下面的形式：
$$L_{o}(x,w_{o})=I_{diff}+f_{rs}(x,w_{i},w_{o})L_{i}(x,w_{i})(n\cdot w_{i})$$
$I_{diff}$：漫反射分量
$f_{rs}(x,w_{i},w_{o})$：高光反射的BRDF函数
---
## BRDF光照模型
### 什么是BRDF光照模型
* BRDF(Bidirectional Reflectance Distribution Function)，中文为双向反射分布函数，是一个用来描述表面如何反射光线的方程
* BRDF就是一个描述光如何从给定的两个方向（入射光方向和出射方向）在表面进行反射的函数
* BRDF的结果是一个没有单位的数值，表示在给定入射条件下，某个出射方 向上反射光的相对能量，也可以理解为“入射光以特定方向离开的概率"
* 如图所示，$w_{i}$表示光线入射方向，$w_{o}$表示光线出射方向，则该情况下的BRDF值表示：光线以$w_{i}$方向入射，然后以$w_{o}$方向出射的概率，或者光强
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader6/BRDF.PNG"  width=400></img></center>

* 依据光学原理，BRDF 的计算公式为：
$$f_{r}(w_{i},w_{o})=\frac{dL_{r}(w_{o})}{dE_{i}(w_{i})}=\frac{dL_{r}(w_{o})}{L_{i}(w_{i})cos\theta_{i}dw_{i}}$$
$L_{r}(w_{o})$：从$w_{o}$方向反射的光线的辐射亮度
$E_{i}(w_{i})$：从$w_{i}$方向入射的光线的辐射照度
* 辐射亮度和辐射照度是表示光照性质的光学量，辐射亮度是每单位立体角在垂直于给定方向的平面上的单位正投 影面积上的功率。辐射照度则是整个入射表面的功率，等于投射在包括该点的一 个面元上的辐射通量$d\phi$除以该面元的面积$dA$
* 从物理光学上我们可以将公式理解为：BRDF函数计算的是“特定反射方向的光强与入射光强的比例”
### BRDF的性质
* 可逆性：BRDF的可逆性源自于亥姆霍兹光路可逆性（Helmholtz Recoprpcity Rule）。BRDF的可逆性即，交换入射光与反射光，并不会改变BRDF的值
* 能量守恒性质：BRDF需要遵循能量守恒定律。能量守恒定律指出：入射光的能量与出射光能量总能量应该相等
* 线性特征：很多时候，材质往往需要多重BRDF计算以实现其反射特性。表面上某一点的全部反射辐射度可以简单地表示为各BRDF反射辐射度之和。例如，镜面漫反射即可通过多重BRDF计算加以实现
### BRDF的模型分类
* 经验模型（Empirical Models）：使用基于实验提出的公式对 BRDF 做快速估计，上一章的漫反射光照模型和Phong高光模型都是经验模型
* 数据驱动的模型（Data-driven Models）：采集真实材质表面在不同光照角度和观察角将BRDF按照实 测数据建立查找表，记录在数据库中，以便于快速的查找和计算
* 基于物理的模型（Physical-based Models）：根据物体表面材料的几何以及光学属性建立反射方程，从而计算 BRDF，实现极具真实感的渲染效果
---
## PBR前置知识
* 基于物理的渲染(PBR, Physically-based rendering)是计算机图形学中用数学建模的方式模拟物体表面各种材质散射光线的属性从而渲染照片真实图片的技术
* 基于物理的BRDF模型通过包含材质的各种几何及光学性质来尽可能精确的近似现实世界中 的材料。而一个基于物理的BRDF要必须满足至少如下两条BRDF的特性：能量守恒、亥姆 霍兹光路可逆性
### 次表面散射
* 在真实世界中许多物体都是半透明的，当光入射到透明或半透明材料表面时，一部分被反射，一部分被吸收，还有一部分经历透射。这些半透明的材质受到数个光源的透射，物体本身就会受到材质的厚度影响而显示出不同的透光性，光线在这些透射部分也可以互相混合、干涉
* 次表面散射（Subsurface Scattering），就是光射入半透明材质后在内部发生散射，最后射出物体并进入视野中产生的现象，是指光从表面进入物体经过内部散射，然后又通过物体表面的其他顶点出射的光线传递过程
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader6/SSS.PNG"  width=400></img></center>

### 菲涅尔反射
* 菲涅尔反射（Fresnel Reflectance），即当光入射到折射率不同的两个材质的分界面时，一部分光会被反射，而我们所看到的光线会根据我们的观察角度以不同强度反射的现象
* 关于菲涅尔反射，一个很好的例子是一池清水。从水池上笔直看下去（也就是与法线成零度角的方向）的话，我们能够一直看到池底。而如果从接近平行于水面的方向看去的话，水池表面的高光反射会变得非常强以至于你看不到池底
### 微平面理论
* 微表面理论假设表面是由不同方向的微小细节表面，也就是微平面（microfacets）组成。每一 个微小的平面都会根据它的法线方向在一个方向上反射光线
* 表面法线朝向光源方向和视线方向中间的微表面会反射可见光。然而，不是所有的表面法线和半角法线（half normal）相等的微表面都会反射光线，因为其中有些会被遮挡
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader6/miscrofaces.PNG"  width=600></img></center>

### 各向异性
* 各向异性(anisotropy)与均向性相反，是指在不同方向具有不同行为的性质，也就是其行为与方向有关。如在物理学上，沿着材料做不同方向的量测，若会出现不同行为，通常称该材料具有某种“各向异性”，这样的材料表面称为各向异性表面（anisotropic surface）
* 由于材质有组织的细微凹凸结构的不同，各向异性也分为基本的三种类型（如下图所示）
    * 线性各向异性
    * 径向各向异性
    * 圆柱形各向异性，实际上线性各向异性，单被映像为圆柱形
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader6/anisotropy.PNG"  width=800></img></center>

---
### Cook-Torrance光照模型
* Cook-Torrance模型是图形学中最早的基于物理的BRDF模型，基于微表面理论
* Cook-Torrance 模型将光分为两个方面考虑：漫反射光强和镜面反射光强，如公式所示：
$$I_{c-t}=I_{diff}+I_{spec}=I_{diff}+k_{s}I_{l}R_{s}$$
$I_{diff}$是漫反射光强，该部分的计算方法与前面相同，$k_{s}I_{l}R_{s}$是高光反射光强
* $R_{s}$称为specular term，公式为：
$$R_{s}=\frac{F*D*G}{(N\cdot V)*(N\cdot L)}$$
$F$：Fresnel反射系数（Fresnel reflect term），表示反射方向上的光强占原始光强的比率
$D$：微平面分布函数（Beckmann distribution factor），返回的是“给定方向上的微平面的分数值”
$G$：几何衰减系数（Geometric attenuation term），衡量微平面自身遮蔽光强的影响
$N$：法向量
$V$：视线方向
$L$：入射光方向
* Fresnel反射系数：
$$F=f_{0}+(1-f_{0})(1-V\cdot H)^5$$
$f_{0}$：入射角度接近0时的Fresnel反射系数
$H$：半角向量，即$L+V$
* 微平面分布函数：根据给定的半角向量$H$，微平面分布函数返回微平面的分数值。最常使用的微平面分布函数是Backmann分布函数：
$$D=\frac{1}{m^{2}cos^{4}\alpha}e^{-\frac{tan^{2}\alpha }{m^{2}}}$$
$m$用于度量表面的粗糙程度，较大的m值对应于粗糙平面，较小的m值对应与较光滑的表面
$\alpha$：顶点法向量$N$和半角向量$H$的夹角
其中
$$-\frac{tan^{2}\alpha }{m^{2}}=-\frac{\frac{1-cos^{2}\alpha}{cos^{2}\alpha}}{m^{2}}=\frac{cos^{2}\alpha-1}{m^{2}*cos^{2}\alpha}=\frac{(N\cdot H)^{2}-1}{m^{2}*(N\cdot H)^{2}}$$
所以Backmann微平面分布函数的最终数学表达为公式：
$$D=\frac{1}{m^{2}cos^{4}\alpha}e^{\frac{(N\cdot H)^{2}-1}{m^{2}*(N\cdot H)^{2}}}=\frac{1}{m^{2}(N\cdot H)^{4}}e^{\frac{(N\cdot H)^{2}-1}{m^{2}*(N\cdot H)^{2}}}$$
* 微平面上的入射光，在到达一个表面之前或被该表面反射之后，可能会被相 邻的微平面阻挡，未被遮挡的光随机发散，最终形成了表面漫反射的一部分。这种阻挡会造成镜面反射的轻微昏暗，可以用几何衰减系数来衡量这种影响
* 微平面上反射的光可能出现三种情况：入射光未被遮挡，此时到达观察者的光强为1；入射光部分被遮挡；反射光部分被遮挡。几何衰减系数被定义为：到达观察者的光的最小强度。所以：
$$G=min(1,G_{1},G_{2})\\G_{1}=\frac{2(N\cdot H)(N\cdot L)}{V\cdot H}\\G_{2}=\frac{2(N\cdot H)(N\cdot V)}{V\cdot H}$$
* Cook-Torrance光照模型的specular term的最终数学公式为：
$I_{c-t}=I_{diff}+I_{spec}=I_{diff}+k_{s}I_{l}R_{s}\\=I_{diff}+k_{s}I_{l}\frac{(f_{0}+(1-f_{0})(1-V\cdot H)^5)\frac{1}{m^{2}(N\cdot H)^{4}}e^{\frac{(N\cdot H)^{2}-1}{m^{2}*(N\cdot H)^{2}}}min(1,\frac{2(N\cdot H)(N\cdot L)}{V\cdot H},\frac{2(N\cdot H)(N\cdot V)}{V\cdot H})}{V\cdot H}$
* 最终效果如图，可以看出从不同角度观察，顶部的高光强度是不同的
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader6/cook_front.PNG"  width=400></img><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader6/cook_top.PNG"  width=400></img></center>

---
### Bank BRDF光照模型
* Bank BRDF属于经验模型，由于其计算简单，且效果良好，所以该模型在各向异性光照效果的模拟方面非常有用
* Bank BRDF的高光反射部分公式为：
$$f=k_{s}(\sqrt{1-(L\cdot T)^{2}}\sqrt{1-(V\cdot T)^{2}}-(L\cdot T)(V\cdot T))^{n_{s}}$$
$k_{s}$：高光反射颜色
$n_{s}$：高光系数
$T$：该点的切向量
* 模型渲染效果如图，可以看出比较明显的各向异性的光照效果
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader6/bank.PNG"  width=400></img></center>
---