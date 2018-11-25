
cd ./Dependencies
cd ./generateSuperpixels
mex SLIC.cpp
cd ..

cd ./createIndexTree/multi-segmentation
mex mexMergeAdjRegs_Felzenszwalb.cpp
cd ..
cd ..

cd ./extractFeatures/matlabPyrTools/MEX
compilePyrTools
cd ..
cd ..

cd ./edison_matlab_interface
compile_edison_wrapper
cd ..
cd ..

cd ./postprocessing/propagation
mex vgg_kmiter.cxx
cd ..
cd ..

cd ..