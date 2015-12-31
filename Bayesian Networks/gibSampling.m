% Gibbs Sampling
% Format: ( [variable; variableValue], [envidence1, envidence2, envidence3.....; envidenceValue1, envidenceValue2,envidenceValue3... ] )
% N is the number of original samples
function estimatedPro = gibSampling( que, envid, N)

% Initialize the sample
samples = initialize(envid);

% Iterate for N-1 times to get N samples
% varIndexList = setdiff(1:10, envidence(1,:));
varIndexList = setdiff(1:9, envid(1,:));
for sampleIndex = 2:N
    
    % update sample by modify the variables
    tempVector = samples(sampleIndex-1,:);
    for varIndex = varIndexList
        if rand(1) <= zeroProb(tempVector, varIndex)
            tempVector(varIndex) = 0;
        else
            tempVector(varIndex) = 1;
        end
    end
    
    % add the sample to samples
    samples = [samples; tempVector];
end

% Calculate the Probability
number = 0;
for sampleIndex = 1:N
    if samples(sampleIndex, que(1)) == que(2)
        number = number + 1;
    end
end
estimatedPro = number / (N+1);
    
    
    
    
    
    
    
    
    
    
    
        