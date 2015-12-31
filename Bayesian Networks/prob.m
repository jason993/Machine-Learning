% get the probability
function probalility = prob(N)

probalility = [];
for i = 1:(2^N)
    temp_prob = rand(1);
    probalility = [probalility; temp_prob; 1-temp_prob];
end