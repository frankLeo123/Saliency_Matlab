function bndIdx = GetBndSupIdx(lblImg, thickness)
% Get super-pixels on image boundary
% lblImg    --  is an integer image, values in [1..spNum]
% thickness --  means boundary band width

if nargin < 2
    thickness = 8;
end

bndIdx=unique([
    unique( lblImg(1:thickness,:) );
    unique( lblImg(end-thickness+1:end,:) );
    unique( lblImg(:,1:thickness) );
    unique( lblImg(:,end-thickness+1:end) )
    ]);