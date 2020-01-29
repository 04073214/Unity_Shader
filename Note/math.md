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