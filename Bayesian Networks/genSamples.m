% generate samples from a BN network
function oriSamples = genSamples(N)

oriSamples = [];

% % Either get BNnets and save
% BNnet = BNs();
% save BNnet.mat BNnet;

% OR load BNnets from files
%if exist('BNnet','var')
    load BNnet.mat;
%end


for i = 1:N
    % sample = 1:10;
    sample = 1:9;
    
    % generate a sample    
    probHere = 0;
    % for index = 1:10
    for index = 1:9
        % get the prob here.
        if BNnet{index}{1}(1) == 0
            probHere = BNnet{index}{2}(1);
        elseif BNnet{index}{1}(1) == 1
            parent = BNnet{index}{1}(2);
            parentValue = sample(parent);
            probHere = BNnet{index}{2}( parentValue*2+1 );
        elseif BNnet{index}{1}(1) == 2
            leftparent = BNnet{index}{1}(2);
            rightparent = BNnet{index}{1}(3);
            leftparentValue = sample(leftparent);
            rightparentValue = sample(rightparent);
            probHere = BNnet{index}{2}( leftparentValue*4+rightparentValue*2+1 );
%         elseif BNnet{index}{1}(1) == 3
%            leftparent = BNnet{index}{1}(2);
%            rightparent = BNnet{index}{1}(3);
%            midparent = BNnet{index}{1}(4);
%            leftparentValue = sample(leftparent);
%            rightparentValue = sample(rightparent);
%            midparentValue = sample(midparent);
%            probHere = BNnet{index}{2}(midparentValue*8 + leftparentValue*4+rightparentValue*2+1 + sample(index) );    
        end
        
        % sample in the specific variable
        if rand(1) <= probHere
            sample(index) = 0;
        else 
            sample(index) = 1;
        end
    end
    
    oriSamples = [oriSamples; sample];
end

oriSamples;


    
