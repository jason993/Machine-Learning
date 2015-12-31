% Format: ( [variable; variableValue], [envidence1, envidence2, envidence3.....; envidenceValue1, envidenceValue2,envidenceValue3... ] )
% N is the number of original samples
function estimatedPro = rejSampling( query, envidence, N)

% get the original samples
oriSamples = genSamples(N);

% reject all the samples that do not agree with the envidence
leftSamples = [];
for i = 1:N
    sample = oriSamples(i,:);
    if ( sum(sample(envidence(1,:))~= envidence(2,:)) == 0 )
        leftSamples = [ leftSamples; sample ];
    end
end

% calculate the pro
number = 0;
numberofLeftSamples = size(leftSamples, 1);
for i = 1:numberofLeftSamples
    sampleHere = leftSamples(i,:);
    if sampleHere(query(1)) == query(2)
        number = number +1;
    end
end

estimatedPro = (number) / (numberofLeftSamples+1);