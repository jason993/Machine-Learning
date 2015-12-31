function [m, V] = FindEigendigits(A)
%
%   Input:
%       A: data matrix, each column is one image, x by k
%   Output: 
%       m: mean vector of all images
%       V: eigenvectors w.r.t eigenvalues in descening order
%

[dim, k] = size(A);
m = mean(A, 2);
X = A - repmat(m, 1, k);
if(k < dim)
    Sigma = X'*X;
    [eigVectors, eigenValues] = eig(Sigma);
    eigenValues = diag(eigenValues);
    [~, idx] = sort(eigenValues, 'descend');
    V = eigVectors(:, idx);
    V = X*V;
    for i = 1 : k
        V(:,i) = V(:,i)/norm(V(:,i));
    end
else
    Sigma = X*X';
    [eigVectors, eigenValues] = eig(Sigma);
    eigenValues = diag(eigenValues);
    [~, idx] = sort(eigenValues, 'descend');
    V = eigVectors(:, idx(1:dim));
end

end