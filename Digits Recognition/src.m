% main function to drive the program
% 
%   Input: N: an array of number of sample size
%          T: an array of number of princeple of eigenvalue to choose
%          K: number of Nearest neighbor
%   Output: array of error based on different parameter configuration
%
clear; clc; close all;
K = 5;

%==============================================================
arrerr = [];   %  explore the effact of number of sample size
iter = floor(log2(60000)); 

for i = 4: iter
    N = 2.^i
    T = min(N, 64);
    err = hw1FindEigendigits(N, T, K);
    arrerr = [arrerr err];
    
end

x = 4 : 1: iter;
plot(2.^x, arrerr);

%==================Explore the number of top eigenvector==========
arrerr1 = [];
N = 784;
iter = floor(log2(N));
for i = 2: iter
    T = 2.^i
tic;   err = hw1FindEigendigits(N, T, K);      toc
    arrerr1 = [arrerr1 err];
    
end


x = 2 : 1: iter;
plot(2.^x, arrerr1);

%===================Explore the number of K========================

arrerr2 = [];
N = 512;
T= 64;
for i = 2: 15
    K =i
    err = hw1FindEigendigits(N, T, K);
    arrerr2 = [arrerr2 err];
    
end

x = 2 : 1: 15;
plot(x, arrerr2);
