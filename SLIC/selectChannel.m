function [ result ] = selectChannel( Yh,num,left,right )
%SELECTCHANNEL 此处显示有关此函数的摘要
%   此处显示详细说明
result=0;
num1=0;num2=0;
high=-1;low=-1;
% flag_high=0;flag_low=0;
for i=1:num
    if i> left && i< right
        if (Yh(i)>Yh(i+1)) && (Yh(i)>Yh(i+2))&& (Yh(i)>Yh(i+3))&& (Yh(i)>Yh(i-3)) && (Yh(i)>Yh(i-1)) && (Yh(i)>Yh(i-2))
            high=Yh(i); 
            num1=num1+1;
        end
         if (Yh(i)<Yh(i+1)) && (Yh(i)<Yh(i+2))&& (Yh(i)<Yh(i+3))&& (Yh(i)<Yh(i-3)) && (Yh(i)<Yh(i-1)) && (Yh(i)<Yh(i-2))
            low=Yh(i);
            num2=num2+1;
        end
    end
    if(high~=-1) && (low~=-1)
        result=result+high-low;
        high=-1;low=-1;
    end
end
    num_result=min(num1,num2);
    result=result/num_result;
end

