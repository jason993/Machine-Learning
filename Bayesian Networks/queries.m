% Queries
function [query, envidence] = queries(envidenceNumber)

%generate the query
query  = [1; 0];
% query(1) =  randi([1 10]);
query(1) =  randi([1 5]);
query(2) =  randi([0 1]);

% generate the envidence
envidence = ones(2, envidenceNumber);
for i=1:envidenceNumber
    while 1
        % envidence(1,i) = randi([1 10]);
        envidence(1,i) = randi([1 5]);
        for j=1:i
            if envidence(1,i) == envidence(1,j)
                break;
            end
        end
        if j == i
            envidence(2,i) = randi([0 1]);
            break;
        end
    end
end