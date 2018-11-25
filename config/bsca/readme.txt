The code is for paper "Saliency Detection via Cellular Automata" by Yao Qin, Huchuan Lu, Yiqun Xu and He Wang[1].
To appear in Proceedings of IEEE Conference on Computer Vision and Pattern Recognition (CVPR 2015), Boston, June, 2015.
written by Yao Qin£¬ Yiqun Xu and He Wang
Email:yaoqindlut@gmail.com
******************************************************************************************************************
The code is tested on Windows 7 with MATLAB R2012b.
******************************************************************************************************************
Usage:
1. demo_BSCA
>put the test images into file '\test'
>edit the image name 'imnames' in demo_BSCA.m
>run 'demo_BSCA.m'

2. demo_SCA
>put the test images into file '\test'
>put the saliency maps of one existing algorithm into file '\priormap'
>edit the image name 'imnames' and 'imName_prior'in demo_SCA.m
>run 'demo_SCA.m'

3. demo_MCA
>put the saliency maps of 5 different algorithms into file '\saliencymap1~5'
>edit the image name 'imnames1~5' and 'imName_prior1~5'in demo_MCA.m
>run 'demo_MCA.m'

Note: 
1. We observe that some images on the MSRA dataset are surrounded with artificial frames,which will invalidate the used boundary prior. Thus, we run a pre-processing to remove such obvious frames.
2. We utilize the SLIC execution file 'SLICSuperpixelSegmentation.exe' of the published work [2] ( http://ivrg.epfl.ch/research/superpixels ). Make sure the input image be .bmp file to execute 'SLICSuperpixelSegmentation.exe'.

References:
[1] Yao Qin, Huchuan Lu, Yiqun Xu and He Wang. Saliency Detection via Cellular Automata. IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2015.
[2] R. Achanta, A. Shaji, K. Smith, A. Lucchi, P. Fua, and S. Susstrunk. Slic superpixels. Technical Report, EPFL, 2010.
