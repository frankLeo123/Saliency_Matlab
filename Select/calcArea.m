% function [ leftMax,rightMax,leftMin,rightMin,areaMax,areaMin,distance,label ] = calcArea( imgSingle )
function [ x1,x2,gapNum,areaMax,areaMin,distance,label ] = calcArea( imgSingle )

% Y = [2573;1205;4937;4121;1667;4543;27224;1403;7576;20436;14192;4547;5854;1495;2984;2043];
% x1 = 0.1250,x2 = 0.1875;



% clear all;
% pic =imread('E:\Dataset\img\testE\img\0016.jpg');
% disp('===============')
% numSlic = 100;
% compactness = 20;
% [hsi,h,s,i] = rgb2hsi(pic);
% imgSingle = SLICSingle(h,numSlic,compactness);

% max min idx
x1 = -1;x2 = -1;
gapNum = -1;
gapIdx = -1;
[Y,X]=imhist(imgSingle,16);
label = 0;
distance = 0;
areaMax = 0;
areaMin = 0;
max_idx = 1;
leftMax = -1;
rightMax = -1;
leftMin = -1;
rightMin = -1;
num = length(Y);
% num = max(num_);
% [Ys,Xs]=imhist(imgSingle ,256);
left =max_idx+1;
right = num - max_idx;
high = zeros(1,num);
Yh = reshape(Y,1,num);
for i = left : right
    if (Yh(i)>Yh(i+1)) && (Yh(i)>Yh(i-1))
        high(i)=Yh(i);
    end
end

% black is not consided
i = 1;
if (Yh(i)>Yh(i+1))
    high(i)=Yh(i);
end



i = num;
if (Yh(i)>Yh(i-1))
    high(i)=Yh(i);
end


% sort
high(high < 1000) = 0;
[gray_num,x]  =sort(high,'descend');
% x1 = floor(x(1) * 255/num);
% x2 = floor(x(2) * 255/num);
x1 = x(1)/num;

% single
if gray_num(2) == 0
%     disp('plot is single');
    label = 1;
    return;
end;

% second
x2 = x(2)/num;
% find fenggu
gap = zeros(1,7);
j = 1;
k =0;
for i = min(x(1),x(2))+1: max(x(1),x(2))-1
    if Yh(i)<Yh(i-1)
        if Yh(i)<Yh(i+1)
%             disp('gap is exitsts');
            gap(j) = i;
            j = j+1;
        elseif Yh(i) == Yh(i+1)
            %             k = i;
            while(Yh(i) == Yh(i+1))
                i = i+1;
            end;
            if(Yh(i) < Yh(i+1))
%                 disp('fenggu is exitsts');
                gap(j) = i;
                j = j+1;
            end;
            
        end;
    end;
end;

distance = abs(x(1)-x(2));

if length(gap(gap > 0)) ==1
%     disp('gap is only');
    gapIdx = gap(1);
    gapNum = Yh(gapIdx);
    areaMax = sum(Yh(min(x(1),gap(1)):max(x(1),gap(1))));
    areaMin = sum(Yh(min(x(2),gap(1)):max(x(2),gap(1))));
    %     max
    if x(1) > x(2)
        leftMax = gap(1);
        rightMin = gap(1);
    else
        rightMax = gap(1);
        leftMin = gap(1);
    end;
    
elseif length(gap(gap > 0)) == 0
%     disp('gap is empty');
    
else
%     disp('gap is multi');
    gap = gap(gap > 0);
    right = gap(length(gap));
    left = gap(1);
    gapNum = min(Yh(left),Yh(right));
    if x(1)<x(2)
        rightMax =left;
        leftMin = right;
        areaMax = sum(Yh(x(1):left));
        areaMin = sum(Yh(right:x(2)));
    else
        leftMax = right;
        rightMin = left;
        areaMax = sum(Yh(right:x(1)));
        areaMin = sum(Yh(x(2):left));
    end;
end;

%   left
if x(1)<x(2)
    if x(1) == 1
        leftMax =1;
    elseif x(2) == num
        rightMin  = num;
    end;
    for i = x(1):-1:2
        if Yh(i)<Yh(i+1) && Yh(i)<Yh(i-1)
            % disp('MAX Left gap is exitsts');
            leftMax = i;
            areaMax = areaMax + sum(Yh(i:x(1)));
            break;
        elseif i ==2
            leftMax = 1;
            areaMax = areaMax + sum(Yh(1:x(1)));
        end;
    end;
    for i = x(2):num -1
        if Yh(i)<Yh(i+1) && Yh(i)<Yh(i-1)
            % disp('MIN right gap is exitsts');
            rightMin = i;
            areaMin = areaMin + sum(Yh(x(2):i));
            break;
        elseif i == num-1
            rightMin = num;
            areaMin = areaMin + sum(Yh(x(2):num-1));
        end;
    end;
elseif x(2)<x(1)
    if x(2) == 1
        leftMin =1;
    elseif x(1) == num
        rightMax  = num;
    end;
    for i = x(1):num -1
        if Yh(i)<Yh(i+1) && Yh(i)<Yh(i-1)
            %disp('MAX right gap is exitsts');
            rightMax = i;
            areaMax = areaMax + sum(Yh(x(1):i));
            break;
        elseif i == num-1
            rightMax = num;
            areaMax = areaMax + sum(Yh(x(1):num-1));
        end;
    end;
    for i = x(2):-1:2
        if Yh(i)<Yh(i+1) && Yh(i)<Yh(i-1)
            %disp('Min Left gap is exitsts');
            leftMin = i;
            areaMin = areaMin + sum(Yh(i:x(2)));
            break;
        elseif i ==2
            leftMin = 1;
            areaMin = areaMin + sum(Yh(1:x(2)));
        end;
    end;
end;

if leftMax == -1 ||rightMax == -1 || leftMin == -1|| rightMin == -1
    disp('error')
end;
if gapNum ==-1
    disp('gap is not exists')
end;






