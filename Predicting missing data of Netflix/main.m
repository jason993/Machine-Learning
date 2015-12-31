%   Input: hw3_netflix.mat
%          rowN: # of the uses; colN: # of movies
%          K: reduction of dimension
%   Output: array of error based on different parameter configuration
%
clear; clc; close all;
load hw3_netflix.mat;

[rowN, colN] = size(Ratings);
K = 10;
iter = 30;
%=======Training for the lemda========

I = eye(K);
RMSE_tr = [];
for lemda = 0.05: .05 : 1
    RMSE1 = [];
  for i = 1 : 10    
       trR1=trR;
       trR1(cvSet(i,:)) = 0;
       [r,c] = find(trR1);
    U = randi(2,[rowN, K]);
    M = randi(2,[colN, K]);   
   for j = 1: iter
       for k = 1: colN
        ind = find(c == k);
        Uk = U(r(ind),:);
        %M(k,:) = inv(Uk'*Uk + lemda.*I)* Uk'* trR1(r(ind),k);
        M(k,:) = (Uk'*Uk + lemda.*I)\ Uk'* trR1(r(ind),k);
       end
       
       for q = 1 : rowN
        ind = find(r ==q);
        Mk = M(c(ind),:);
        %U(q,:) = inv(Mk'*Mk + lemda.*I)* Mk'* trR1(q,c(ind))';
        U(q,:) = (Mk'*Mk + lemda.*I)\ Mk'* trR1(q,c(ind))';
       end
   end
   PredictedRatings1 = U*M'; 
   err = sqrt(sum(sum((PredictedRatings1(cvSet(i,:))-trR(cvSet(i,:))).^2))/length(cvSet(i,:)));
   RMSE1 = [RMSE1, err];
  end
  RMSE_tr = [RMSE_tr,mean(RMSE1)]
end

plot(lemda, RMSE_tr1,'r-*');
savefile = 'RESE_tr3file.mat';
save(savefile, 'RMSE_tr');

 %===========calculate the RMSE for the whole data set==================
 trR1=trR;
 [r,c] = find(trR1);
 
 U = randi(2,[rowN, K]);
 M = randi(2,[colN, K]); 
 opt_lemda = 1;
 for j = 1: iter
       for k = 1: colN
        ind = find(c == k);
        Uk = U(r(ind),:);
        %M(k,:) = inv(Uk'*Uk + lemda.*I)* Uk'* trR1(r(ind),k);
        M(k,:) = (Uk'*Uk + opt_lemda.*I)\ Uk'* trR1(r(ind),k);
       end
       
       for q = 1 : rowN
        ind = find(r ==q);
        Mk = M(c(ind),:);
        %U(q,:) = inv(Mk'*Mk + lemda.*I)* Mk'* trR1(q,c(ind))';
        U(q,:) = (Mk'*Mk + opt_lemda.*I)\ Mk'* trR1(q,c(ind))';
       end
 end
 PredictedRatings = U*M'; 
 RMSE = sqrt(sum(sum((PredictedRatings(testIdx)-Ratings(testIdx)).^2))/length(testIdx));
 