% determine the optimal policy by value iteration
% this is for the 5 by 5 grid world 

numactions = 4; % for north, south, east, and west
xsize = 5; % ranging from 1 to 5
ysize = 5; % ranging from 1 to 5

% let us number the states from 1 
states = [1:xsize*ysize];

% define the probabilistic transition and rewards matrix
% this says which actions taken in which states, lead where.
% a lot of simplifications are made in this code, since
%  - at each cell, all actions are possible
%  - transitions are deterministic

for oldstate=1:size(states,2)
  for action=1:numactions
	% figure out old coordinates
	oldx = floor((oldstate-1)/ysize)+1;
	oldy = oldstate-((oldx-1)*ysize);
	% figure out new coordinates
	if (action == 1) % north
	   if (oldx > 1)
		newx = oldx-1; newy = oldy; rew = 0;
	   else
		newx = oldx; newy = oldy; rew = -1;
	   end
	end
	if (action == 2) % south
	   if (oldx < xsize)
		newx = oldx+1; newy = oldy; rew = 0;
	   else
		newx = oldx; newy = oldy; rew = -1;
	   end
	end
	if (action == 3) % east
	   if (oldy < ysize)
		newx = oldx; newy = oldy+1; rew = 0;
	   else
		newx = oldx; newy = oldy; rew = -1;
	   end
	end
	if (action == 4) % west
	   if (oldy > 1)
		newx = oldx; newy = oldy-1; rew = 0;
	   else
		newx = oldx; newy = oldy; rew = -1;
	   end
	end
	% the following two rules are exceptions to the above
	% rules for directional movement.
	% this silly MATLAB version does not have a continue
	% construct, hence the sloppy overwriting
	if (oldx == 1 && oldy == 2)
		newx = 5; newy = 2; rew = 10;
		% i.e., irresp. of action
	end 
	if (oldx == 1 && oldy == 4)
		newx = 3; newy = 4; rew = 5;
		% i.e., irresp. of action
	end
	newstate = (newx-1)*ysize+newy;
	transfer(oldstate,action) = newstate;
	rewards(oldstate,action) = rew;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now, the rest of the code is specific to what you want to do 
% with this RL problem. Here, we are trying to find the optimal
% policy. Both pi and V are not given! We initialize the
% value arbitrarily, update it, and spit out a policy only at the end

% gamma is the discounting rate
gamma = 0.9;

% initialize V values arbitrarily
% currently they are all 0.1
for i=1:size(states,2)
	Vvalues(i) = 0.1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% there are two main steps here
% first, a different backup for policy evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
del = 10;
%%%% error_threshold is made more stricter
error_threshold = 0.0001;

while del > error_threshold,
del = 0;
  for i=1:size(states,2)
    newVvalues = [];
    v = Vvalues(i);
    for j=1:numactions
       newVvalues = [newVvalues ...
%%%% this line below used to have a pi in it
                  rewards(i,j) + gamma*Vvalues(transfer(i,j))];
    end
    Vvalues(i) = max(newVvalues);
    del = max([del abs(v - Vvalues(i))]);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now spit out the policy
% we spit out a probabilistic policy, not just
% a deterministic one

for i=1:size(states,2)
    newprobs = [];
    for j=1:numactions
       newprobs = [newprobs (rewards(i,j) + ...
                  gamma*Vvalues(transfer(i,j)))];
    end
    highest = max(newprobs);
    % determine the actions that have this V value (highest)
    count = 1;
    for j=1:numactions
           if (abs(newprobs(j) - highest) < 1E-04)
                 pi(i,j) = 1;
           else
                 pi(i,j) = 0;
           end
    end
    pi(i,:) = pi(i,:)/sum(pi(i,:));
end

pi
