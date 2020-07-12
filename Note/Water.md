# 水体渲染
---
## 简单水体
* 贴图+UV动画
* 使用一张噪声纹理，采样结果作为UV的偏移值，从而模拟水流动的效果
<center><img src="https://ian824.gitee.io/blogpic/img/unity-shader-water/SimpleWater.gif"  width=400></img></center>

* ```
    // sample the texture
    fixed4 noise_col = tex2D(_NoiseTex, i.uv + fixed2(_Time.y*_XSpeed, 0));
    fixed uOffset = noise_col.r;
    fixed vOffset = noise_col.r;
    fixed4 col = tex2D(_MainTex, i.uv +_Intensity*fixed2(uOffset, vOffset));
    ```
  * `_Intensity`为水流动的强度
  * `_XSpeed`为水流动的速度

* 完整代码：https://github.com/kb824999404/Unity_Shader/blob/master/Shader/Test/Water/SimpleWater.shader
---
## 水波
* 波纹内部有拉伸效果，随时间变化：用距离中心的长度和时间作为输入，通过三角函数计算拉伸值，`_distanceFactor`为波峰波谷数量，`_totalFactor`为最大拉伸强度，`_timeFactor`为拉伸强度变化速度
    ```
    float sinFactor = sin(dis * _distanceFactor + _Time.x * _timeFactor) * _totalFactor;
    ```
* 波纹从内向外扩散：波纹半径随时间递增，不超过最大半径`_maxWaveDis`，`waveWidth`为波纹宽度，如果纹理坐标距离当前波纹运动点的距离超过该值则不拉伸
    ```
    float curWaveDis = frac(_Time.x *_waveSpeed)*_maxWaveDis;
    //距离当前波纹运动点的距离，如果小于waveWidth才予以保留，否则已经出了波纹范围，factor通过clamp设置为0
    float discardFactor = clamp(_waveWidth - abs(curWaveDis - dis), 0, 1);
    ```
* 将纹理坐标进行网格细分，使水波随机出现在各个网格内，并且一个扩散周期后再次随机出现，`_GridNum`为细分网格数量，`_RippleDensity`为水波密度
    ```
    float2 st=frac(i.uv*_GridNum);     //网格内坐标
    float2 grid=floor(i.uv*_GridNum);    //网格坐标 
    float2 dv=float2(st.x-0.5,st.y-0.5);    
    float dis=length(dv);           //距网格中心距离

    //使用floor取整，一个水波扩散周期内不变
    float flag_change=floor(_Time.x *_waveSpeed);    
    //用网格坐标和flag_change生成随机值，大于_RippleDensity为1，用于判断该网格是否有水波
    //这样水波随机出现在各个网格内，且一个水波扩散周期内不消失
    float flag_ripple=step(random(grid+flag_change),_RippleDensity);  
    ```
* 最后综合计算结果，得到偏移值
```
//归一化
float2 dv1 = normalize(dv);
//计算每个像素uv的偏移值
float2 offset = dv1  * sinFactor*discardFactor*flag_ripple;
```
* 水波可能不太明显，可以加上水波的颜色（效果好像不太好）
<center><img src="https://ian824.gitee.io/blogpic/img/unity-shader-water/RippleWater.gif"  width=400></img></center>

* 完整代码：https://github.com/kb824999404/Unity_Shader/blob/master/Shader/Test/Water/RippleWater.shader
---
## 波浪
* 顶点动画，这里采用线性波形叠加方法，`_WaveScale`为波浪数量，`_WaveStrength`为波浪强度
* 需要注意的是，如果使用Unity中自带的模型，顶点数过少，会产生整个模型上下摇动的效果，而不是出现波浪，因此可以在Blender里建一个平面，细分到有足够多的顶点
    ```
    float calculateSurface(float x, float z, float scale)
    {
        float y = 0.0;
        y += (sin(x * 1.0 / scale + _Time.y * 1.0) + sin(x * 2.3 / scale + _Time.y * 1.5) + sin(x * 3.3 / scale + _Time.y * 0.4)) / 3.0;
        y += (sin(z * 0.2 / scale + _Time.y * 1.8) + sin(z * 1.8 / scale + _Time.y * 1.8) + sin(z * 2.8 / scale + _Time.y * 0.8)) / 3.0;
        return y;
    }
    v2f vert (appdata v)
    {
        v2f o;
        v.vertex.z += _WaveStrength * calculateSurface(v.vertex.x, v.vertex.y, _WaveScale);
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        UNITY_TRANSFER_FOG(o,o.vertex);
        return o;
    }
    ```
<center><img src="https://ian824.gitee.io/blogpic/img/unity-shader-water/WaveWater.gif"  width=400></img></center>

* 完整代码：https://github.com/kb824999404/Unity_Shader/blob/master/Shader/Test/Water/WaveWater.shader
---
## 折射反射
* 折射：使用`GrabPass{}`在渲染水面前获取屏幕图像，作为水下贴图，在此基础上渲染水面
* 反射：创建一个相机捕获从水面出发捕获到的景象，建立一个`RenderTexture`将`RenderTexture`赋给相机的`Render Target`存储获取的图像，再将`RenderTexture`赋给水体`material`的`_ReflectTex`
* 菲涅尔反射：使用菲涅尔等式计算反射光和折射光的比例
  $$F_{schlick}(v,n)=F_{0}+(1-F_{0})(1-v\cdot n)^{5}$$
  然后按比例混合反射光和折射光
    ```
    //反射纹理采样
    fixed3 reflectColor=tex2D(_ReflectTex,coord);

    //水下纹理采样
    fixed3 refractColor=tex2D(_GrabTex, (i.scrPos.xy+offset)/i.scrPos.w).rgb;
    //菲涅尔等式计算反射和折射比例
    fixed fresnel=_FresnelScale+(1-_FresnelScale)*pow(1-dot(worldViewDir,worldNormal),5);

    //混合反射光和折射光
    fixed3 fresnelColor=lerp(refractColor, reflectColor, saturate(fresnel));
    ```
* 水贴图采样，添加高光和阴影，结果：
    ```
    fixed3 color = ambient+(waterColor +specular+fresnelColor ) * atten;
    ```
<center><img src="https://ian824.gitee.io/blogpic/img/unity-shader-water/AllWater.gif"  width=400></img></center>

* 完整代码：https://github.com/kb824999404/Unity_Shader/blob/master/Shader/Test/Water/AllWater.shader

---

**本文代码：** https://github.com/kb824999404/Unity_Shader/blob/master/Shader/Test/Water

---
**参考：** 

https://blog.csdn.net/v_xchen_v/article/details/79676335
https://blog.csdn.net/v_xchen_v/article/details/79782900

https://blog.csdn.net/puppet_master/article/details/52975666

https://zhuanlan.zhihu.com/p/95917609

https://www.pianshen.com/article/5191278740/