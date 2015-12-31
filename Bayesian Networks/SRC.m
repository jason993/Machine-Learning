clc;

% generate the query and the envidence
 
    clear;

    % make a query
    query = {[1; 1];[2; 1];[3; 1];[4; 1];[5; 1];[6; 1]};
    envidence = {[7 8 9;1 0 0];[7 8 9;1 0 1];[7 8 9;0 1 0];[7 8 9;0 1 1]};
    
    % Use Rejection Sampling 
    N = 100000;
    rejsamplePro = [];
    for i = 1: 4
       for j = 1:6
           rejsamplePro(i,j) = rejSampling(query{j}, envidence{i}, N);
       end 
    end
    
    
    % Use Gibbs Sampling
    gibsamplePro = [];
    for i = 1: 4
       for j = 1:6
           gibsamplePro(i,j) = gibSampling(query{j}, envidence{i}, N);
       end 
    end
    

