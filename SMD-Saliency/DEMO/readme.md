This package contains our implementation for:
"Salient Object Detection via Structured Matrix Decomposition"
===========================================================================
*** The code is run on MATLAB R2012a-2014a on Windows 7 or Linux  - 32/64 bit.

Usage:
>> put the input images into file '\INPUT_IMG'
>> put the groundtruth images into file '\GROUND_TRUTH'
>> run 'compile.m'
>> run 'demo.m'
>> the output saliency maps are stored in the file '\SAL_MAP'
>> the evaluation results are stored in the file '\results'

===========================================================================
Reference:
[1] H. Peng, B. Li, R. Ji, W. Hu, W. Xiong, and C. Lang, Salient object detection via low-rank and structured sparse matrix decomposition, in AAAI, 2013.
[2] X. Shen and Y. Wu, A unified approach to salient object detection via low rank matrix recovery, in CVPR, 2012, pp. 2296~2303.
[3] P. Felzenszwalb and D. Huttenlocher, Efficient graph-based image segmentation,¡± International Journal of Computer Vision, vol. 59, no. 2, pp. 167~181, 2004.
[4] W. Zhu, S. Liang, Y. Wei, and J. Sun, Saliency optimization from robust background detection, CVPR, Columbus, OH, USA, June 23-28, 2014, 2014, pp. 2814~2821.


===========================================================================
Q&A:
Q:  Running Error: undefined funtion or variable "graphallshortestpaths"
A:  graphallshortestpaths is a function to compute the shortest path on a graph. This function is included in Matlab Bioinformatics Toolbox. 
    If you do not install this toolbox, this error will be pop out. So, the solution is to install/add the toolbox into your Matlab.

Q:  The results in terms of AUC are not consistent to ones reported in http://arxiv.org/pdf/1410.5926v1.pdf
A:  We analyze the AUC measure implementation in the above paper, and find that their implementation is a little different from ours, so the results are not
    consistent. The main difference is that our AUC measure eliminates the influence of center bias, which is shown to have an important effect on the final performance.
    In order to reduce the impact of the inconsistency, we include these two kinds of AUC implementations into the released source code (See /Dependencies/evaluation-Parfor/ReadMe.txt and EvaluateMetrics_HuaizuJiang.m).
