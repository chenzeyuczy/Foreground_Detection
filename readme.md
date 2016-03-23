# 动态背景下的前景提取

> 本项目为本科毕业设计的题目。

本实验旨在提出一种动态背景下的快速前景算法。首先，利用帧差、GMM[1]等方法计算出图像中等运动区域，然后结合GOP算法[2]得到的object proposal选取初步前景区域，并对用前后帧的proposal进行二分匹配，修正前景结果。接着使用对图像的超像素点[3]进行流形排序[4]，以初步结果中的超像素为对探测点，构建像素点间的图模型。在排序后的基础上利用大津算法[5]实施二值化分割，得到最终的前景结果。

### 创新点
  - 将流形排序应用于前景提取领域
  - 对前后帧的前景结果使用二分匹配进行修复
  - 在不使用光流信息的前提下实现对动态背景下的前景提取

### 数据集
[SegTrack数据集](http://cpl.cc.gatech.edu/projects/SegTrack/)

### 运行环境
* 操作系统：Windows 10 专业版64位
* 编程语言：Matlab 2015b
* 第三方库：[vlfeat](http://www.vlfeat.org/)

### 运行方法
1. 下载源码至本地`git clone https://github.com/chenzeyuczy/Foreground_Detection.git`。
2. 打开项目目录`cd Foreground`。
3. 在“Preprocess/import_data.m”文件中设置数据集路径。
3. 运行主程序`main()`。

### 发布协议
[MIT](https://opensource.org/licenses/mit-license.php)

### 引用
- [1].	LI, Hao; ACHIM, Alin; BULL, David R. GMM-based efficient foreground detection with adaptive region update. In: Image Processing (ICIP), 2009 16th IEEE International Conference on. IEEE, 2009. p. 3181-3184.
- [2].	P. Krahenbuhl and V. Koltun. Geodesic Object Proposals. ECCV. 2014. 725-739.
- [3].	R. Achanta, A. Shaji, K. Smith, A. Lucchi, P. Fua and S. Susstrunk. SLIC Superpixels Compared to State-of-the-Art Superpixel Methods. IEEE Transactions on Pattern Analysis and Machine Intelligence. 2012. 2274-2282.
- [4].	Zhou D, Weston J, Gretton A. Ranking on Data Manifolds[J]. Neural Information Processing Systems, 2004
- [5].	Nobuyuki Otsu. A Threshold Selection Method from Gray-Level Histograms. IEEE Transactions on Systems, Man and Cybernetics. 1979. 9 (1): 62–66.