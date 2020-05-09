# 光照模型
---
## 我们是如何看到这个世界的

* 当光照射到物体表面时，一部分被物体表面吸收(absorption)，另一部分被散射(scattering)
* 散射有两种方向：一种散射到物体内部，称为折射(refraction)或透射(transmission)；另一种散射到外部，称为反射(reflection)
* 对于不透明物体，折射进物体内部的光线一部分与内部颗粒相交，重新发射出物体表面，这部分光线与具有与反射光线不同的方向分布和颜色
* 对于透明物体而言，一部分光穿过透明体，产生透射光
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader5/scatter.PNG"  width=400></img></center>

* 为了区分这两种不同的散射方向，在光照模型中使用不同的部分来计算：高光反射(specular)表示反射光线，漫反射(diffuse)表示被折射、吸收和重新散射出表面的光线
* 所以，物体表面光照颜色由入射光、物体材质，以及材质和光的交互规律共同决定
---
## 标准光照模型
* 标准光照模型只关心直接光照，也就是那些直接从光源发射出来照射到物体表面后，经过物体表面的一次反射直接进入摄像机的光线
* 标准光照模型把进入到摄像机内的光线分为以下4个部分
* 自发光(emissive)：物体表面自身发射出的光线，用$c_{emissive}$表示
* 高光反射(specular)：反射光线，用$c_{specular}$表示
* 漫反射(diffuse)：重新散射出表面的光线，用$c_{diffuse}$表示
* 环境光(ambient)：其他所有间接光照，用$c_{ambient}$表示
---
### 环境光
* 物体也可以被间接光照所照亮，间接光照指的是，光线通常会在多个物体之间反射，最后进入摄像机
* 理想的环境光具有如下特性：没有空间或方向性；在所有方向上和所有物体表面上投射的环境光强度是统一的恒定值
* 环境光通常用一个全局变量计算，所有物体都相同：
$$c_{ambient}=m_{ambient}$$
* 考虑物体材质的情况下，使用以下公式计算：
$$c_{ambient}=k_{albedo}m_{ambient}$$
$k_{albedo}(0<k_{albedo}<1)$：材质在某点处的反射系数
---
### 自发光
* 光线直接由物体发射进入摄像机，不需要经过任何物体的反射，这部分直接使用该材质的自发光颜色计算：
$$c_{emissive}=m_{emissive}$$
* 通常自发光的表面不会照亮周围表面，这个物体不会被当成一个光源
---
### 漫反射
* 漫反射：粗糙的物体表面向各个方向等强度地反射光，这种等同地向各个方向散射的现象称为光的漫反射（diffuse reflection）
* 产生光的漫反射现象的物体表面称为理想漫反射体，也称为朗伯（Lambert）反射体
* 即使一个理想的漫反射体在所有方向上具有等量的反射光线，但是表面光强还依赖于光线的入射方向。例如，入射光方向垂直的表面与入射光方 向成斜角的表面相比，其光强要大的多。这种现象可以用 Lambert 定律进行数学 上的量化。
#### Lambert模型
* Lambert 定律：当方向光照射到朗伯反射体上时，漫反射光的光强与入射光的方向和入射点表面法向夹角的余弦成正比，由此构造出 Lambert 漫反射模型：
$$c_{diffuse}=(c_{light}\cdot m_{diffuse})max(0,cos\theta)$$
$c_{light}$：入射光线的颜色和强度
$m_{diffuse}$：材质的漫反射系数
$cos\theta$：入射角，即入射光方向与顶点法线的夹角
* 若$n$为顶点单位法向量，$I$表示从顶点指向光源的单位向量，则$cos\theta$等价于$n$与$I$的点积，则
$$c_{diffuse}=(c_{light}\cdot m_{diffuse})max(0,n\cdot I)$$
#### 半Lambert模型
* Lambert模型存在一个问题，在光照无法到达的区域，模型通常是全黑的，没有任何明暗变化，这会使模型的背光区域看起来就像一个平面，失去了模型细节表现
* 为了解决这个问题，在Lambert模型的基础上进行修改，称为半Lambert模型
* 广义的半Lambert模型公式如下：
$$c_{diffuse}=(c_{light}\cdot m_{diffuse})(\alpha(n\cdot I)+\beta)$$
* 半Lambert模型没有使用$max$来防止$n\cdot I$为负值，而是进行$\alpha$倍的缩放和$\beta$大小的偏移
* 大多数情况下$\alpha$和$\beta$为0.5，公式为：
$$c_{diffuse}=(c_{light}\cdot m_{diffuse})(0.5(n\cdot I)+0.5)$$
通过这样的方式，可以把$n\cdot I$的结果从[-1,1]映射到[0,1]范围内
* 半Lambert模型是没有物理依据的，只是一个视觉加强技术
#### 效果对比
* 下图为逐顶点漫反射光照、逐像素漫反射光照和半Lambert光照的对比效果
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader5/diffuse.PNG"  width=600></img></center>
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader5/diffuse_girl.PNG"  width=600></img></center>

---
### 高光反射
* Lambert 模型较好地表现了粗糙表面上的光照现象，如石灰粉刷的墙壁、纸张等，但在用于诸如金属材质制成的物体时，则会显得呆板，表现不出光泽
* 高光反射(镜面反射)：一个光滑物体被光照射时， 可以在某个方向上看到很强的反射光，这是因为在接近镜面反射角的一个区域内，反射了入射光的全部或绝大部分光强
#### Phong模型
* Phong模型：Phong Bui Tuong 提出的一个计算高光反射光强的经验模型，认为镜面反射的光强与反射光线和视线的夹角相关，即
$$c_{specular}=(c_{light}\cdot m_{specular})max(0,v\cdot r)^{m_{gloss}}$$
$m_{gloss}$：材质的光泽度，用于控制高光区域的“亮点”有多宽，$m_{gloss}$越大，高光越集中，亮点越小
$m_{specular}$：材质的高光反射颜色
$v$：从顶点到视点的观察方向
$r$：反射光方向
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader5/phong.PNG"  width=400></img></center>

* 反射光$r$的方向可以通过入射光方向$I$和顶点单位法向量求出：
$$r+I=(2n\cdot I)n\\
r=(2n\cdot I)n-I$$
#### Blinn-Phong模型
* Blinn-Phong光照模型，是由Blinn对传统Phong光照模型基础上进行修改提出的。和Phong光照模型相比， Blinn-Phong光照模型混合了Lambert的漫射部分和标准的高光，渲染效果有时比Phong高光更柔和、更平滑
* Blinn-Phong模型的基本思想是避免计算反射方向$r$，引入一个新的矢量$h$，用$n\cdot h$的值代替$v\cdot r$
* Blinn-Phong模型公式为
$$c_{specular}=(c_{light}\cdot m_{specular})max(0,n\cdot h)^{m_{gloss}}\\
h=\frac{v+I}{|v+I|}$$
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader5/blinn.PNG"  width=400></img></center>

* Blinn-Phong光照模型省去了计算反射光线方向向量的两个乘法运算，速度更快
#### 效果对比
* 下图为逐顶点高光反射光照、逐像素高光反射光照(Phong模型)和Blinn-Phong高光反射光照的对比效果
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader5/specular.PNG"  width=600></img></center>
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader5/specular_girl.PNG"  width=600></img></center>


---
## Unity内置函数
<center><img src="https://cdn.jsdelivr.net/gh/kb824999404/blogPic/img/unity-shader5/unityfunc.PNG"  width=800></img></center>