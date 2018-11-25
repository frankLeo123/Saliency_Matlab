inputpath = 'F:\dataset\4test\PASCALS\select\lab\';
outputpathHSI = 'F:\dataset\4test\PASCALS\select\lab\';

Files=dir([inputpath  '*.png']);
mkdir(outputpathHSI);
number=length(Files);
%
for num=1:number
    disp(num);
    pic = imread([inputpath Files(num).name]);
    
    [x,y,z] = size(pic);
    res = zeros(x,y,3);
    if z == 1  
        disp('single error')
        res(:,:,1) =pic;
        res(:,:,2) =pic;
        res(:,:,3) =pic;
        res = double(res/255);
    else
        res = pic;
    end;
        path_name = [outputpathHSI Files(num).name(1:end-4) '.jpg'];
        imwrite(res,path_name);
end;

