# 数学基础
---
## 矩阵变换
### 线性变换(Linear Transform)
* 可以保留矢量加和标量乘的变换，即$f(x)+f(y)=f(x+y),kf(x)=f(kx)$，可以用$3\times3$矩阵表示
* 线性变换包括缩放、旋转、错切、镜像、正交投影等变换
* 平移变换满足标量乘法，但不满足标量加法，不是线性变换，不能用$3\times3$矩阵表示
### 仿射变换(Affine Transform)
* 合并线性变换和平移变换的变换
* 仿射变换可以用$4\times4$矩阵表示，把三维矢量扩展到四维空间，就是齐次坐标空间(Homogeneous Space)
<center><img src="image/Math/transform.png"  width=400></img></center>

### 齐次坐标(Homogeneous Coordinate)
* 三维矢量转换为四维坐标即齐次坐标（四维齐次坐标）
* 对于一个点，从三维坐标转换为齐次坐标是把$w$分量设为1，对于方向向量，把$w$分量设为0
* 当用一个$4\times4$矩阵对一个点进行变换时，线性变换和平移变换都会作用于该点，但对一个方向矢量进行变换时，平移变换会被忽略
### 基础变换矩阵
* 表示纯平移、纯旋转和纯缩放的变换矩阵叫做基础变换矩阵
* 可以把一个基础变换矩阵分解为4个部分：
    $$\begin{bmatrix}
   M_{3\times 3} & t_{3\times 1} \\
   0_{1\times 3} & 1 
  \end{bmatrix}$$
$M_{3\times 3}$用于表示旋转和缩放，$t_{3\times 1}$用于表示平移
### 平移矩阵
* 对点进行平移变换
$$\begin{bmatrix}   
    1&0&0&t_{x} \\
    0&1&0&t_{y} \\
    0&0&1&t_{z} \\
    0&0&0&1
\end{bmatrix}
\begin{bmatrix}
    x\\
    y\\
    z\\
    1
\end{bmatrix}=
\begin{bmatrix}
    x+t_{x}\\
    y+t_{y}\\
    z+t_{z}\\
    1
\end{bmatrix}$$
* 对方向矢量进行平移变换
$$\begin{bmatrix}   
    1&0&0&t_{x} \\
    0&1&0&t_{y} \\
    0&0&1&t_{z} \\
    0&0&0&1
\end{bmatrix}
\begin{bmatrix}
    x\\
    y\\
    z\\
    0
\end{bmatrix}=
\begin{bmatrix}
    x\\
    y\\
    z\\
    0
\end{bmatrix}$$
* 平移矩阵的逆矩阵就是反向平移得到的矩阵
$$\begin{bmatrix}   
    1&0&0&-t_{x} \\
    0&1&0&-t_{y} \\
    0&0&1&-t_{z} \\
    0&0&0&1
\end{bmatrix}$$
### 缩放矩阵
$$\begin{bmatrix}   
    k_{x}&0&0&0 \\
    0&k_{y}&0&0 \\
    0&0&k_{z}&0 \\
    0&0&0&1
\end{bmatrix}
\begin{bmatrix}
    x\\
    y\\
    z\\
    1
\end{bmatrix}=
\begin{bmatrix}
    k_{x}x\\
    k_{y}y\\
    k_{z}z\\
    1
\end{bmatrix}$$
* 缩放矩阵的逆矩阵是使用原缩放系数的倒数来对点或方向矢量进行缩放
$$\begin{bmatrix}   
    \frac{1}{k_{x}}&0&0&0 \\
    0&\frac{1}{k_{y}}&0&0 \\
    0&0&\frac{1}{k_{z}}&0 \\
    0&0&0&1
\end{bmatrix}$$
### 旋转矩阵
* 绕$x$轴旋转$\theta$度
$$\begin{bmatrix}   
    1&0&0&0 \\
    0&cos\theta&-sin\theta&0 \\
    0&sin\theta&cos\theta&0 \\
    0&0&0&1
\end{bmatrix}$$
* 绕$y$轴旋转$\theta$度
$$\begin{bmatrix}   
    cos\theta&0&sin\theta&0 \\
    0&1&0&0 \\
    -sin\theta&0&cos\theta&0 \\
    0&0&0&1
\end{bmatrix}$$
* 绕$z$轴旋转$\theta$度
$$\begin{bmatrix}   
    cos\theta&-sin\theta&0&0 \\
    sin\theta&cos\theta&0&0 \\
    0&0&1&0 \\
    0&0&0&1
\end{bmatrix}$$
### 复合变换
* 一般先缩放，再旋转，最后平移
* 给定一个旋转顺序（如$zyx$）以及它们对应的旋转角度$(\theta_{x},\theta_{y},\theta_{z})$，有两种坐标系可以选择，把它们的旋转顺序颠倒一下，得到的结果就一样
    >* 绕坐标系$E$下的$z$轴旋转$\theta_{z}$,绕坐标系$E$下的$y$轴旋转$\theta_{y}$,绕坐标系$E$下的$x$轴旋转$\theta_{x}$,即进行一次旋转时不一起旋转当前坐标系
    >* 绕绕坐标系$E$下的$z$轴旋转$\theta_{z}$,在坐标系$E$下再绕$z$轴旋转$\theta_{z}$后的新坐标系$E'$下的$y$轴旋转$\theta_{y}$,在坐标系$E'$下再绕$y$轴旋转$\theta_{y}$后的新坐标系$E''$下的$x$轴旋转$\theta_{x}$,即在旋转时，把坐标系一起转动
* 给出$(\theta_{x},\theta_{y},\theta_{z})$这样的旋转角度时，需定义一个旋转顺序，在Unity中，这个旋转顺序是$zxy$(第一种情况)，即复合旋转变换矩阵为
$$M_{rotat\theta_{Z}}M_{rotat\theta_{X}}M_{rotat\theta_{Y}}=\begin{bmatrix}   
    cos\theta&-sin\theta&0&0 \\
    sin\theta&cos\theta&0&0 \\
    0&0&1&0 \\
    0&0&0&1
\end{bmatrix}
\begin{bmatrix}   
    1&0&0&0 \\
    0&cos\theta&-sin\theta&0 \\
    0&sin\theta&cos\theta&0 \\
    0&0&0&1
\end{bmatrix}
\begin{bmatrix}   
    cos\theta&0&sin\theta&0 \\
    0&1&0&0 \\
    -sin\theta&0&cos\theta&0 \\
    0&0&0&1
\end{bmatrix}$$
---
## 坐标空间
## 坐标空间的变换
* 定义一个坐标空间，必须指明其原点位置和3个坐标轴的方向，这些数值实际上是相对于另一个坐标空间的，因此，坐标空间会形成一个层次结构————每个坐标空间都是另一个坐标空间的子空间，每个空间都有一个父坐标空间，对坐标空间的变换实际上就是在父空间和子空间之间对点和矢量进行变换
* 假设有父坐标空间$P$和子坐标空间$C$，已知子坐标空间$C$的3个坐标轴在父坐标空间$P$下的表示$x_{c}$、$y_{c}$、$z_{c}$，以及其原点位置$O_{c}$
    >* 把子坐标空间下表示的点或矢量$A_{c}$转换到父坐标空间下的表示$A_{p}$，可以使用从子坐标空间变换到父坐标空间的变换矩阵$M_{c\rightarrow p}$，$A_{p}=M_{c\rightarrow p}A_{c}$
    >* 把父坐标空间下表示的点或矢量$B_{p}$转换到子坐标空间下的表示$B_{c}$，可以使用$M_{c\rightarrow p}$的逆矩阵$M_{p\rightarrow c}$，$B_{c}=M_{p\rightarrow c}B_{p}$
    >$$M_{c\rightarrow p}=\begin{bmatrix}   
    |&|&|&| \\
    x_{c}&y_{c}&z_{c}&O_{c} \\
    |&|&|&| \\
    0&0&0&1\end{bmatrix}$$
    >* 对方向矢量的坐标空间变换，坐标空间的原点变换可以忽略，变换矩阵可以用$3\times 3$矩阵
    >$$M_{c\rightarrow p}=\begin{bmatrix}   
    |&|&| \\
    x_{c}&y_{c}&z_{c}\\
    |&|&|\end{bmatrix}$$
    >* 若$M_{c\rightarrow p}$为正交矩阵
    >$$M_{p\rightarrow c}=M_{c\rightarrow p}^{T}=\begin{bmatrix}   
    -&x_{c}&- \\
    -&y_{c}&-\\
    -&z_{c}&-\end{bmatrix}$$
    >*从变换矩阵也可以获取子坐标空间的原点和坐标轴方向
* 在渲染流水线中，一个顶点经过多个坐标空间的变换最终被画在屏幕上，一个顶点最开始是在模型空间中定义的，最后变换到屏幕空间中，得到真正的屏幕像素坐标
### 模型空间(Model Space)
* 模型空间又称对象空间(Object Space)或局部空间(Local Space)，是每个模型独立的坐标空间，随着模型移动和旋转
### 世界空间(World Space)
* 世界空间是我们所关心的最大、最外层的坐标空间，可以用于描述绝对位置
* 顶点变换的第一步，就是将顶点坐标从模型空间变换到世界空间中，这个变换称为模型变换(Model Transform)
### 观察空间(View Space)
* 观察空间又称摄像机空间(Camera Space)，摄影机位于原点
* Unity中模型空间和世界空间使用左手坐标系，观察空间使用右手坐标系
* 顶点变换的第二步，就是将顶点坐标从世界空间变换到观察空间中，这个变换称为观察变换(View Transform)
### 裁剪空间(Clip Space)
* 顶点变换的第三步，从观察空间转换到裁剪空间，变换矩阵叫做裁剪矩阵(Clip Matrix)，又称投影矩阵(Projection Matrix)
* 裁剪空间的目标是能够方便地对渲染图元进行裁剪：完全位于这块空间内部的图元将会被保留，完全位于这块空间外部的图元将会被剔除，而与这块空间边界相交的图元就会被裁剪，这块空间由视锥体来决定
* 视锥体(View Frustum)是摄像机可以看到的空间，由六个平面包围而成，这些平面也称为裁剪平面(Clip Planes)，包括近裁剪平面(Near Clip Plane)、远裁剪平面(Far Clip Plane)和侧面的4个裁剪平面
* 投影有两种类型：正交投影(Orthographic Projection)和透视投影(Perspective Projection)，在透视投影中，平行线不会保持平行，离摄像机越近网格越大，离摄像机越远网格越小，模拟了人眼看世界的方式，视锥体是金字塔形。在正交投影中，平行线保持平行，完全保留了物体的距离和角度，视锥体是长方体
* 透视投影：
    >* Field of View(FOV):视锥体竖直方向的张开角度
    >* Near:近裁剪平面与摄像机的距离
    >* Far:远裁剪平面与摄像机的距离
    >* Aspect:摄像机的横纵比
    >$$M_{frustum}=\begin{bmatrix}   
    \frac{cot\frac{FOV}{2}}{Aspect}&0&0&0 \\\\
    0&cot\frac{FOV}{2}&0&0 \\\\
    0&0&-\frac{Far+Near}{Far-Near}&-\frac{2\cdot Near\cdot Far}{Far-Near} \\\\
    0&0&-1&0\end{bmatrix}$$
    >$P_{clip}=M_{frustum}P_{view}$
    $$=\begin{bmatrix} \frac{cot\frac{FOV}{2}}{Aspect}&0&0&0 \\\\
    0&cot\frac{FOV}{2}&0&0 \\\\
    0&0&-\frac{Far+Near}{Far-Near}&-\frac{2\cdot Near\cdot Far}{Far-Near} \\\\
    0&0&-1&0\end{bmatrix}\begin{bmatrix}
    x\\y\\z\\1 
    \end{bmatrix}$$
    $$=\begin{bmatrix}
    x\frac{cot\frac{FOV}{2}}{Aspect}\\\\
    ycot\frac{FOV}{2}\\\\
    -z\frac{Far+Near}{Far-Near}-\frac{2\cdot Near\cdot Far}{Far-Near}\\\\
    -z
    \end{bmatrix}$$
    >* 视锥体内的顶点变换后的坐标满足：$-w\leq x,y,z\leq w$
    ><center><img src="image/Math/perspective.png"  width=400></img></center>
    ><center><img src="image/Math/perspective-frustum.png"  width=600></img></center>
* 正交投影：
    >* Size:视锥体竖直方向上高度的一半
    >$$M_{frustum}=\begin{bmatrix}   
    \frac{1}{Aspect\cdot Size}&0&0&0 \\\\
    0&\frac{1}{Size}&0&0 \\\\
    0&0&-\frac{2}{Far-Near}&-\frac{Far+Near}{Far-Near} \\\\
    0&0&0&1\end{bmatrix}$$
    >$P_{clip}=M_{frustum}P_{view}$
    $$=\begin{bmatrix}   
    \frac{1}{Aspect\cdot Size}&0&0&0 \\\\
    0&\frac{1}{Size}&0&0 \\\\
    0&0&-\frac{2}{Far-Near}&-\frac{Far+Near}{Far-Near} \\\\
    0&0&0&1\end{bmatrix}\begin{bmatrix}
    x\\y\\z\\1 
    \end{bmatrix}$$
    $$=\begin{bmatrix}
    \frac{x}{Aspect\cdot Size}\\\\
    \frac{y}{Size}\\\\
    -\frac{2z}{Far-Near}-\frac{Near+Far}{Far-Near}\\\\1
    \end{bmatrix}$$
    ><center><img src="image/Math/orthographic.png"  width=400></img></center>
    ><center><img src="image/Math/orthographic-frustum.png"  width=600></img></center>
### 屏幕空间(Screen Space)
* 完成裁剪工作后，把顶点从裁剪空间投影到屏幕空间中，来生成对应的$2D$坐标
* 标准齐次除法(Homogenous Division)又称透视除法(Perspective Division)，即用齐次坐标系的$w$分量去除以$x$、$y$、$z$分量，得到归一化的设备坐标(Normalized Device Coordinates,NDC)
* 把NDC坐标映射到窗口的对应像素坐标(Unity中屏幕空间原点为左下角)
$$screen_{x}=\frac{clip_{x}\cdot pixelWidth}{2\cdot clip_{w}}+\frac{pixelWidth}{2}$$
$$screen_{y}=\frac{clip_{y}\cdot pixelHeight}{2\cdot clip_{w}}+\frac{pixelHeight}{2}$$
<center><img src="image/Math/perspective-division1.png"  width=600></img></center>
<center><img src="image/Math/perspective-division2.png"  width=600></img></center>
<center><img src="image/Math/pipeline-transform.png"  width=600></img></center>

---
## 法线变换
* 变换一个模型时，不仅需要变换顶点，还需要变换顶点法线，以便后续计算光照
* 变换法线时使用同一个变换矩阵，可能无法确保维持法线的垂直性
* 根据同一个顶点的切线和法线满足垂直条件可求得变换矩阵为$(M^{-1}_{A\rightarrow B})^{T}$
* 如果变换矩阵是正交矩阵，$(M^{-1}_{A\rightarrow B})^{T}=M_{A\rightarrow B}$，如果只包括旋转变换，那么这个变换矩阵就是正交矩阵。如果只包含旋转和统一缩放，而不包含非统一缩放，$(M^{-1}_{A\rightarrow B})^{T}=\frac{1}{k}M_{A\rightarrow B}$。如果包含非统一变换，则需要求解逆矩阵。
<center><img src="image/Math/normal-transform.png"  width=600></img></center>

---
## Unity Shader的内置变量
### 变换矩阵
<center><img src="image/Math/transform-matrix.png"  width=600></img></center>

### 摄像机和屏幕参数
<center><img src="image/Math/camera-screen1.png"  width=600></img></center>
<center><img src="image/Math/camera-screen2.png"  width=600></img></center>

---
