function [mean1, scalar1] = scalar(arr,start,last)
%SCALAR Summary of this function goes here
%   Detailed explanation goes here
min1= min(arr(start:last)); max1= max(arr(start:last)); mean1 = 0.5*(min1 + max1); scalar1 = max1 - min1;

end

