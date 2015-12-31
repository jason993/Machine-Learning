% determine the optimal policy by policy iteration
% this is for the 5 by 5 grid world 
clear, clc;
numactions = 4; % for north, south, east, and west
xsize = 25; % ranging from 1 to 5
ysize = 3; % ranging from 1 to 5

% let us number the states from 1 
states = [1:xsize*ysize];

DrawGrid(xsize,ysize);
hold on;
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
		newx = oldx-1; newy = oldy; rew = -1;
	   else
		newx = oldx; newy = oldy; rew = -1;
	   end
	end
	if (action == 2) % south
	   if (oldx < xsize)
        % get to the end of the sidewalk get reward   
		newx = oldx+1; newy = oldy; rew = 0; 
	   else
		newx = oldx; newy = oldy; rew = 0;
	   end
	end
	if (action == 3) % east
	   if (oldy < ysize)
		newx = oldx; newy = oldy+1; rew = -1;
	   else
		newx = oldx; newy = oldy; rew = -1;
	   end
	end
	if (action == 4) % west
	   if (oldy > 1)
		newx = oldx; newy = oldy-1; rew = -1;
	   else
		newx = oldx; newy = oldy; rew = -1;
	   end
	end
	% the following two rules are exceptions to the above
	% rules for directional movement.
	% this silly MATLAB version does not have a continue
	% construct, hence the sloppy overwriting
	if (oldx == 24 && action ==2)
		newx = 25; newy=oldy; rew = 1;
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
% policy. Both pi and V are not given! We initialize each
% arbitrarily and do staged iterations involving policy evaluation
% and policy improvement

% initialize pi arbitrarily
% currently they are all equiprobable
% but you can set them to anything you want
% make sure laws of probability are satisfied
for i=1:size(states,2)
  for j=1:numactions
    pi(i,j) = 1/numactions;
  end
end

% gamma is the discounting rate
gamma = 0.9; 
% alpha is the learning rate
alpha = 0.9;

% initialize V values arbitrarily
% currently they are all 0.1
for i=1:size(states,2)
    for j=1:numactions
	 Qvalues(i,j) = 0;
    end
end


oldx = 1; 
oldy = randi([1,3],1);

iteration = 10000;
for iter = 1: iteration
%oldx = randi([1,24],1); 

%while oldx ~= 25
    for j=1:numactions
        %v = Qvalues(i,j);
        action = j;
        %oldx = floor((oldstate-1)/ysize)+1;
        %oldy = oldstate-((oldx-1)*ysize);
        % figure out new coordinates
        if (action == 1) % north
            if (oldx > 1)
                newx = oldx-1; newy = oldy;                 
            else
                newx = oldx; newy = oldy; 
            end
            num = ysize*(newx -1) + newy;  
            Qnext(1,action)= max(Qvalues(num,:)); %+ rewards(oldy*(oldx -1) + oldy,action);
        end
        if (action == 2) % south
            if (oldx < xsize)
                % get to the end of the sidewalk get reward
                newx = oldx+1; newy = oldy;
            else
                newx = oldx; newy = oldy; 
            end
            num = ysize*(newx -1) + newy;  
            Qnext(1,action)= max(Qvalues(num,:)); %+rewards(oldy*(oldx -1) + oldy,action);
        end
        if (action == 3) % east
            if (oldy < ysize)
                newx = oldx; newy = oldy+1; 
            else
                newx = oldx; newy = oldy; 
            end
            num = ysize*(newx -1) + newy;  
            Qnext(1,action)= max(Qvalues(num,:)); %+rewards(oldy*(oldx -1) + oldy,action);
        end
        if (action == 4) % west
            if (oldy > 1)
                newx = oldx; newy = oldy-1;  
            else
                newx = oldx; newy = oldy; 
            end
            num = ysize*(newx -1) + newy;  
            Qnext(1,action)= max(Qvalues(num,:)); %+rewards(oldy*(oldx -1) + oldy,action);
        end
              
    end
    %find the right action which maximize the Qvalue and take that action
    dice = randi([1,10],1);
    move = find(Qnext==max(Qnext));
    if (dice == 1)
       action = randsample([1,2,3,4],1);
    else
       action = randsample(move,1);
    end
   %=====================================================    
    if (size(move,2) >1)
        action = 2;
    end
    if (action == 1) % north
        if (oldx > 1)
            newx = oldx-1; newy = oldy;
        else
            newx = oldx; newy = oldy;
        end
        
    end
    if (action == 2) % south
        if (oldx < xsize)
            % get to the end of the sidewalk get reward
            newx = oldx+1; newy = oldy;
        else
            newx = oldx; newy = oldy;
        end
     
    end
    if (action == 3) % east
        if (oldy < ysize)
            newx = oldx; newy = oldy+1;
        else
            newx = oldx; newy = oldy;
        end
  
    end
    if (action == 4) % west
        if (oldy > 1)
            newx = oldx; newy = oldy-1;
        else
            newx = oldx; newy = oldy;
        end
      
    end
     
    num = ysize*(oldx -1) + oldy;
    DrawActionOnCell(action, oldx,oldy,xsize,ysize,.5);
    Qvalues(num,action) = (1 - alpha) * Qvalues(num,action) + alpha*(rewards(num,action) + gamma*max(Qnext));
    oldx = newx; oldy = newy;
    
 %end

end


changed = 1; count = 0;
while changed == 1,
	   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	   % there are two main steps here
	   % first, policy evaluation; this is ditto copied from
	   % iterpolicyeval.m
	   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           del = 10;
           error_threshold = 0.01;
          
           while del > error_threshold,
               count = count + 1;
               del = 0;
               for i=1:size(states,2)
                   oldstate = i;
                   
                   for j=1:numactions
                       v = Qvalues(i,j);
                       action = j;
                       oldx = floor((oldstate-1)/ysize)+1;
                       oldy = oldstate-((oldx-1)*ysize);
                       % figure out new coordinates
                       if (action == 1) % north
                           if (oldx > 1)
                               newx = oldx-1; newy = oldy; num = newy*(newx -1) + newy;
                               Qnext(1,action)= max(Qvalues(num,:));
                           else
                               Qnext(1,action)= max(Qvalues(oldy*(oldx -1) + oldy,:));
                           end
                       end
                       if (action == 2) % south
                           if (oldx < xsize)
                               % get to the end of the sidewalk get reward
                               newx = oldx+1; newy = oldy; num = newy*(newx -1) + newy;
                               Qnext(1,action)= max(Qvalues(num,:));
                           else
                               Qnext(1,action)= max(Qvalues(oldy*(oldx -1) + oldy,:));
                           end
                       end
                       if (action == 3) % east
                           if (oldy < ysize)
                               newx = oldx; newy = oldy+1; num = newy*(newx -1) + newy;
                               Qnext(1,action)= max(Qvalues(num,:));
                           else
                               Qnext(1,action)= max(Qvalues(oldy*(oldx -1) + oldy,:));
                           end
                       end
                       if (action == 4) % west
                           if (oldy > 1)
                               newx = oldx; newy = oldy-1;  num = newy*(newx -1) + newy;
                               Qnext(1,action)= max(Qvalues(num,:));
                           else
                               Qnext(1,action)= max(Qvalues(oldy*(oldx -1) + oldy,:));
                           end
                       end
                       
                       
                       Qvalues(i,j) = (1 - alpha) * Qvalues(i,j) + alpha*(rewards(i,j) +gamma*max(Qnext));

                   end
                 
                   del = max([del abs(v - Qvalues(i,j))]);
               end
           end
	   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	   % the second step is policy improvement, i.e.,
	   % making the policy greedy w.r.t. the current value
	   % function. this is the new part for this MATLAB code
	   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	   changed = 0;
       for i=1:size(states,2)
           oldpol = pi(i,:); % this is what the current policy states
           newprobs = Qvalues(i,:);
%            newprobs = [];
%            for j=1:numactions
%                %newprobs = [newprobs Qvalues(transfer(i,j))];
%                newprobs = [newprobs (rewards(i,j) + gamma*Qvalues(transfer(i,j)))];
%            end
           highest = max(newprobs);
           % determine the actions that have this Qvalue (highest)
          
           for j=1:numactions
               if (abs(newprobs(j) - highest) < 1E-05)
                   pi(i,j) = 1;
               else
                   pi(i,j) = 0;
               end
           end
           pi(i,:) = pi(i,:)/sum(pi(i,:));
           if ~(norm(oldpol-pi(i,:)) < 1E-05)
               changed = 1;
           end
       end
end

pi
