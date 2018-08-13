function [ result ] = selectChannel( Yh,num )
%SELECTCHANNEL 此处显示有关此函数的摘要
%   此处显示详细说明
result=0;
num=64;
num1=0;num2=0;
sumPix=sum(Yh);
high=-1;low=-1;
temp_max=0;temp_min=0;
% flag_high=0;flag_low=0;
for i=1:num
    if i==2
        if Yh(1)>Yh(2)
            temp_max=1;
            temp_min=2;
        end
        if Yh(2)>Yh(1)
            temp_max=2;
            temp_min=1;
        end
        if temp_max~=0 && Yh(temp_max)>Yh(3) && (Yh(temp_max)>(sumPix/num*2))
            high=Yh(temp_max);
            num1=num1+1;
            n(num1)=temp_max;
            nn(num1)=high;
        end     
        if temp_min~=0 && Yh(temp_min)<Yh(3) && (Yh(temp_min)<(sumPix/num/2))
            low=Yh(temp_min);
            num2=num2+1;
            m(num2)=temp_min;
            mm(num2)=low;
        end
    end
    if i==num
        if Yh(num-1)>Yh(num)
            temp_max=num-1;
            temp_min=num;
        end
        if Yh(num)>Yh(num-1)
            temp_max=num;
            temp_min=num-1;
        end
        if Yh(temp_max)>Yh(num-2) && (Yh(temp_max)>(sumPix/num*2))
            high=Yh(temp_max);
            num1=num1+1;
            n(num1)=temp_max;
            nn(num1)=high;
        end     
        if Yh(temp_min)<Yh(num-2) && (Yh(temp_min)<(sumPix/num/2))
            low=Yh(temp_min);
            num2=num2+1;
            m(num2)=temp_min;
            mm(num2)=low;
        end
    end
    if i>2 && i<num-2
        if (Yh(i)>Yh(i+1)) && (Yh(i)>Yh(i+2)) && (Yh(i)>Yh(i-1)) && (Yh(i)>Yh(i-2))
            high=Yh(i); 
            num1=num1+1;
            n(num1)=i;
            nn(num1)=high;
        end
         if (Yh(i)<Yh(i+1)) && (Yh(i)<Yh(i+2)) && (Yh(i)<Yh(i-1)) && (Yh(i)<Yh(i-2))
            low=Yh(i);
            num2=num2+1;
            m(num2)=i;
            mm(num2)=low;
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

