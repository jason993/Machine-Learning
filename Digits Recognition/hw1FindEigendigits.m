function err = hw1FindEigendigits(N, T, K)
% 
%   Input: 
%       N: number of sample size we take 
%       T: number of Eigenvalue and Eigenvector we take 
%       K: number of Nearest neighbor
%   Output:
%       err: error
%
%   Usage: err = MyExperiment(N, T, K)
%


if nargin < 1
    N = 100;
end
if nargin < 2
    T = 100;
end
if nargin < 3
    K = 10;
end


load digits.mat;
[~,~,testK] = size(testImages);
[~,~,trainK] = size(trainImages);


% N = 10000;  %%%% N is number of sample size we take 
% T = 100; %%% T is number of Eigenvalue and Eigenvector we take 
% K = 10;  %%% K is number of Nearest neighbor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = trainImages(:, :, 1);
dim = length(reshape(I,784,1));

A = zeros(dim, trainK);
for i = 1 : trainK
    A(:,i) = reshape(trainImages(:,:,i),784,1);
end
B = zeros(dim, testK);
for i = 1 : testK
    B(:,i) = reshape(testImages(:,:,i),784,1);
end

sample_A = zeros(784, N);
ridxarr = randperm(trainK);
for i = 1 : N
    %random_int  = ridarr(i);
    random_int  = ridxarr(i);
    sample_A(:,i) = reshape(trainImages(:,:,random_int), 784,1);  
end    

[m, V3] = FindEigendigits(sample_A);
P = V3(:, 1:T);
P = P';


temp_ave = mean(A,2);
A_mean = double(A - repmat(temp_ave, 1, trainK));

trainmatrix = P * A_mean;

temp_ave = mean(B,2);
B_mean = double(B - repmat(temp_ave, 1, testK));

testmatrix = P * B_mean;

[~,Index] = pdist2(trainmatrix',testmatrix','euclidean','Smallest',K);


est_labels = ones(1, testK)*(-1);
for i = 1 : testK
    label = trainLabels(Index(:, i));
    est_labels(i) = mode(double(label));
end

err = length(find(est_labels ~= testLabels)) / length(testLabels)
% plot the graph, set as comment to prvent slowing the program
%=====================plot the reconstruction images===========
% subplot (2,3,1), imshow(reshape(B(:,3),28,28));
% subplot (2,3,4), imshow(reshape((pinv(P)*testmatrix(:,3)),28,28));
% subplot (2,3,2), imshow(reshape(B(:,2),28,28));
% subplot (2,3,5), imshow(reshape((pinv(P)*testmatrix(:,2)),28,28));
% subplot (2,3,3), imshow(reshape(B(:,1),28,28));
% subplot (2,3,6), imshow(reshape((pinv(P)*testmatrix(:,1)),28,28));

% subplot (2,3,1), imshow(reshape(B(:,6810),28,28));
% subplot (2,3,4), imshow(reshape((pinv(P)*testmatrix(:,6810)),28,28));
% subplot (2,3,2), imshow(reshape(B(:,6811),28,28));
% subplot (2,3,5), imshow(reshape((pinv(P)*testmatrix(:,6811)),28,28));
% subplot (2,3,3), imshow(reshape(B(:,6816),28,28));
% subplot (2,3,6), imshow(reshape((pinv(P)*testmatrix(:,6816)),28,28));

%%=============== plot eigenvector figures ==========
%[height, width] = size(I);
%neig = 64;
%MTEigenV = zeros(height, width, 1, neig);
%for i = 1 : neig
%   MTEigenV(:, :, 1, i) = reshape(MyRescale(P(i, :), 0, 1), height, width);
%end
%colormap('jet');
%montage(MTEigenV);


end








