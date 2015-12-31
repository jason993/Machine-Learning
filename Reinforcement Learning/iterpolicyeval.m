% given a policy determine V_pi
% doing it by iterative method, not direct method
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
% with this RL problem. Here, we are given a policy.
% and we iteratively estimate the V values

% pi is given here, to be equiprobable
for i=1:size(states,2)
  for j=1:numactions
    pi(i,j) = 1/numactions;
  end
end

% gamma is the discounting rate
gamma = 0.9;

% initialize V values
for i=1:size(states,2)
	Vvalues(i) = 0;
end

del = 10;
error_threshold = 0.01;
% the following is an admittedly sloppy way to do Gauss-Seidel
% for now, we are merely illustrating the basic idea
while del > error_threshold,
  del = 0;
  for i=1:size(states,2)
    summing = 0;
    v = Vvalues(i);
    for j=1:numactions
      summing = summing + ...
	   pi(i,j)*(rewards(i,j) + gamma*Vvalues(transfer(i,j)));
    end
    Vvalues(i) = summing;
    del = max([del abs(v - Vvalues(i))]);
  end
end

% arrange the V_pi values nicely on a grid
reshape(Vvalues,xsize,ysize)'

