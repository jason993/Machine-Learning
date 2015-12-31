% main function to drive the program
% 
%   Input: sounds, sample U, mix matrix A
%   Output: mix sounds M, recovery sounds R
%
clear; clc; close all;

%==========Test the icaTest.mat data=========
load icaTest.mat;

X = A * U;
[dimr, dimc] = size(U);
W = (.1) .*rand(dimr);

iter = 300000;
step = 0.001;

tic;
for k = 1 : iter
    Y = W*X;
    Z= 1./(1+exp(-Y));
    detaW = step*(eye(dimr)*dimc + (1-2*Z)*Y')/W';
    W = W + detaW;
end
toc;

Y = W*X;
time = 1 : 40;
%========plot the gragh==============

[mean11,scalar11] = scalar(U(1,:), time(1), time(end));
[mean12,scalar12] = scalar(U(2,:), time(1), time(end));
[mean13,scalar13] = scalar(U(3,:), time(1), time(end));

plot(time, 0.5 + (U(1,time(1): time(end)) - mean11)/scalar11,'r-');
hold all
plot(time, 1.5 + (U(2,time(1): time(end)) - mean12)/scalar12,'g-');
plot(time, 2.5 + (U(3,time(1): time(end)) - mean13)/scalar13,'b-');

[mean21,scalar21] = scalar(X(1,:), time(1), time(end));
[mean22,scalar22] = scalar(X(2,:), time(1), time(end));
[mean23,scalar23] = scalar(X(3,:), time(1), time(end));
plot(time, 3.5 + (X(1,time(1): time(end)) - mean21)/scalar21,'r-');
plot(time, 4.5 + (X(2,time(1): time(end)) - mean22)/scalar22,'g-');
plot(time, 5.5 + (X(3,time(1): time(end)) - mean23)/scalar23,'b-');

[mean31,scalar31] = scalar(Y(1,:), time(1), time(end));
[mean32,scalar32] = scalar(Y(2,:), time(1), time(end));
[mean33,scalar33] = scalar(Y(3,:), time(1), time(end));
plot(time, 6.5 + (Y(1,time(1): time(end)) - mean31)/scalar31,'r-');
plot(time, 7.5 + (Y(2,time(1): time(end)) - mean32)/scalar32,'g-');
plot(time, 8.5 + (Y(3,time(1): time(end)) - mean33)/scalar33,'b-');




clear all;
%==========Test the sounds.mat data=========
load sounds.mat;
sound1(1,:) = sounds(1,:) - mean(sounds(1,:));
sound1(2,:) = sounds(2,:) - mean(sounds(2,:));
sound1(3,:) = sounds(3,:) - mean(sounds(3,:));
sound1(4,:) = sounds(4,:) - mean(sounds(4,:));
sound1(5,:) = sounds(5,:) - mean(sounds(5,:));

[dimr, dimc] = size(sound1);
A = rand(dimr)/1;
X = A * sound1;
%W = inv(A) + .5.*(rand(dimr,dimr));
%W = eye(5);
W = (.1) .*rand(5,5);

iter = 10000;
step = 0.0001;
rmse =[];

tic;
for k = 1 : iter
    Y = W*X;
    Z= 1./(1+exp(-Y));
    detaW = step*(eye(dimr)*dimc + (1-2*Z)*Y')/W';
    W = W + detaW;
    
% %============compute the RMSE set as comment to speed the algorithm=================
% Y = W * X;
% E = zeros(5,44000);
% F = zeros(5,44000);
% 
% for i = 1: dimr
% E(i,:) = Y(i,:)/norm(Y(i,:));    
% F(i,:) = sound1(i,:)/norm(sound1(i,:));
% end
% 
% MSE = zeros(dimr,dimr);
% for i = 1:dimr
%     for j= 1:dimr
%        MSE(i,j) = norm(E(i,:) - F(j,:));
%     end
% end
% rmse = [rmse sum(min(MSE))/dimr];
end
toc;
% x = 1 : iter;
% plot(x, rmse);
%============alternative algorithm based on stanford=============
% tic;
% for k = 1: iter
%  deltaW = zeros(dimr, dimr);
%    for j = 1 : dimc
%     Z = 1 - 2./(1 + exp(W' * X(:,j)));
%     deltaW = deltaW + Z * X(:,j)';
%    
%    end
% deltaW = deltaW/dimc + inv(W');
% 
% W = W + step.*deltaW;
% end
% toc;

Y = W * X;

%========set the time range============
time = 1 : 44000;
%========plot the gragh==============
plotfunc(time, sound1, X, Y);

