% In a fixed BNnet, calculate the conditional probability of a Variable
function probHere = condProb( sample, index )

% Load BNnets from files
% if exist('BNnet','var')
     load BNnet.mat;
% end

% Calculate this variable's conditinal probability
if BNnet{index}{1}(1) == 0
    probHere = BNnet{index}{2}(1 + sample(index) );
elseif BNnet{index}{1}(1) == 1
    parent = BNnet{index}{1}(2);
    parentValue = sample(parent);
    probHere = BNnet{index}{2}( parentValue*2+1 + sample(index) );
elseif BNnet{index}{1}(1) == 2
    leftparent = BNnet{index}{1}(2);
    rightparent = BNnet{index}{1}(3);
    leftparentValue = sample(leftparent);
    rightparentValue = sample(rightparent);
    probHere = BNnet{index}{2}( leftparentValue*4+rightparentValue*2+1 + sample(index) );
 elseif BNnet{index}{1}(1) == 3
    leftparent = BNnet{index}{1}(2);
    rightparent = BNnet{index}{1}(3);
    midparent = BNnet{index}{1}(4);
    leftparentValue = sample(leftparent);
    rightparentValue = sample(rightparent);
    midparentValue = sample(midparent);
    probHere = BNnet{index}{2}(midparentValue*8 + leftparentValue*4+rightparentValue*2+1 + sample(index) );   
end
