% determine the optimal policy by policy iteration
% this is for the 3 by 25 grid world 
clear all, clc;
numactions = 4; % for north, south, east, and west
xsize = 25; % ranging from 1 to 25
ysize = 3; % ranging from 1 to 3

% let us number the states from 1 
states = [1:xsize*ysize];

DrawGrid(xsize,ysize);
hold on;
%genetate the obstacles matrix 
obstacles = randi([1 5],25,3);


for i = 1:ysize
    for j = 1:xsize
        if (obstacles(j,i) == 1)
        else
          obstacles(j,i) = 0;
        
        end
    end
end

for i = 1:ysize
    for j = 1:xsize
        if (obstacles(j,i) == 1)
        DrawTextOnCell('O', 0,  j, i, xsize, ysize, 1);    
        end
    end
end
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
		newx = oldx; newy = oldy; rew = 0;
	   end
	end
	if (action == 2) % south
	   if (oldx < xsize)
        % get to the end of the sidewalk get reward   
		newx = oldx+1; newy = oldy; rew = 1; 
	   else
		newx = oldx; newy = oldy; rew = 1;
	   end
	end
	if (action == 3) % east
	   if (oldy < ysize)
		newx = oldx; newy = oldy+1; rew = 0;
	   else
		newx = oldx; newy = oldy; rew = 0;
	   end
	end
	if (action == 4) % west
	   if (oldy > 1)
		newx = oldx; newy = oldy-1; rew = 0;
	   else
		newx = oldx; newy = oldy; rew = 0;
	   end
	end
	% the following two rules are exceptions to the above
	% rules for directional movement.
	% this silly MATLAB version does not have a continue
	% construct, hence the sloppy overwriting

    
%     if (obstacles(newx,newy) ==1)
%         rew = -5;
%     end

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
% currently they are all 0
% for i=1:size(states,2)
%     for j=1:numactions
% 	 Qvalues2(i,j) = 0;
%     end
% end

% objectnum = 3; 
% for i=1:numactions
%     for j=1:objectnum
% 	 Qvalues2(i,j) = 0;
%     end
% end

changed = 1; 
iteration = 8000;

oldx = 1; 
oldy = randi([1,3],1);

% for iter = 1: iteration
%     for i=1:numactions
%         %v = Qvalues(i,j);
%         action = i;
%         
%         %oldx = floor((oldstate-1)/ysize)+1;
%         %oldy = oldstate-((oldx-1)*ysize);
%         % figure out new coordinates
%         if (action == 1) % north
%             if (oldx > 1)
%                 newx = oldx-1; newy = oldy; 
%             else
%                 newx = oldx; newy = oldy;
%             end
%             num = ysize*(newx -1) + newy;
%             Qnext(1,action)= max(Qvalues2(action,:)); %+ rewards(oldy*(oldx -1) + oldy,action);
%         end
%         if (action == 2) % south
%             if (oldx < xsize)
%                 % get to the end of the sidewalk get reward
%                 newx = oldx+1; newy = oldy;
%             else
%                 newx = oldx; newy = oldy;
%             end
%             num = ysize*(newx -1) + newy;
%             Qnext(1,action)= max(Qvalues2(action,:)); %+rewards(oldy*(oldx -1) + oldy,action);
%         end
%         if (action == 3) % east
%             if (oldy < ysize)
%                 newx = oldx; newy = oldy+1;
%             else
%                 newx = oldx; newy = oldy;
%             end
%             num = ysize*(newx -1) + newy;
%             Qnext(1,action)= max(Qvalues2(action,:)); %+rewards(oldy*(oldx -1) + oldy,action);
%         end
%         if (action == 4) % west
%             if (oldy > 1)
%                 newx = oldx; newy = oldy-1;
%             else
%                 newx = oldx; newy = oldy;
%             end
%             num = ysize*(newx -1) + newy;
%             Qnext(1,action)= max(Qvalues2(action,:)); %+rewards(oldy*(oldx -1) + oldy,action);
%         end
%         
%     end
%     %find the right action which maximize the Qvalue and take that action
%     dice = randi([1,10],1);
%     move = find(Qnext==max(Qnext));
%     if (dice == 1)
%         action = randsample([1,2,3,4],1);
%     else
%         action = randsample(move,1);
%     end
%     
%     %action = randsample(move,1);
% %     if (size(move,2) >1)
% %         action = 2;
% %     end
%     if (action == 1) % north
%         if (oldx > 1 )
%             newx = oldx-1; newy = oldy; obj = 1;
%         else 
%             newx = oldx; newy = oldy; obj = 2;
%         end
%         
%     end
%     if (action == 2) % south
%         if (oldx < xsize)
%             % get to the end of the sidewalk get reward
%             newx = oldx+1; newy = oldy; obj = 1;
%         else
%             newx = oldx; newy = oldy; obj = 2;
%         end
%         
%     end
%     if (action == 3) % east
%         if (oldy < ysize)
%             newx = oldx; newy = oldy+1; obj = 1;
%         else
%             newx = oldx; newy = oldy;  obj = 2;
%         end
%         
%     end
%     if (action == 4) % west
%         if (oldy > 1)
%             newx = oldx; newy = oldy-1; obj = 1;
%         else
%             newx = oldx; newy = oldy;  obj = 2;
%         end
%         
%     end
%     if (obstacles(newx,newy) ==1)
%         obj = 3;
%         newx = oldx; newy = oldy;
%     end
%     num = ysize*(oldx -1) + oldy;
%     DrawActionOnCell(action, oldx,oldy,xsize,ysize,.5);
%     Qvalues2(action,obj) = (1 - alpha) * Qvalues2(action,obj) + alpha*(rewards(num,action) + gamma*max(Qnext));
%     oldx = newx; oldy = newy;
% end

%%
load 'Qvalue_no_obs1.mat';
load 'Qvalue_with_obs.mat';
% rowsum = sum(Qvalues,2);
% for i = 1: xsize
%     Qvalues(i,:) = Qvalues(i,:)/rowsum(i);
% end
Qvalues_norm = normr(Qvalues);
Qvalues2_norm = normr(Qvalues2);
wt = 0.8;

oldx = 1; 
oldy = randi([1,3],1);

timeout = 0;
hitcount = 0;
count = 0;
%for iter = 1: iteration
while oldx ~= 25
    count = count +1;
    for i=1:numactions
        %v = Qvalues(i,j);
        action = i;
        if (action == 1) % north
            if (oldx > 1 )
                newx = oldx-1; newy = oldy; obj = 1;
            else   
                newx = oldx; newy = oldy; obj = 2;
            end
            if (obstacles(newx,newy) ==1)
                obj = 3;
                %newx = oldx; newy = oldy;
            end
            Qnext(1,action) = wt* Qvalues_norm(ysize*(oldx -1) + oldy,action)+...
                                  (1-wt)* Qvalues2(action,obj);
        end
        if (action == 2) % south
            if (oldx < xsize)
                % get to the end of the sidewalk get reward
                newx = oldx+1; newy = oldy; obj = 1;
            else
                newx = oldx; newy = oldy; obj = 2;
            end
            if (obstacles(newx,newy) ==1)
                obj = 3;
                %newx = oldx; newy = oldy;
            end
            Qnext(1,action) = wt* Qvalues_norm(ysize*(oldx -1) + oldy,action)+...
                (1-wt)* Qvalues2(action,obj);
            
        end
        if (action == 3) % east
            if (oldy < ysize)
                newx = oldx; newy = oldy+1; obj = 1;
            else
                newx = oldx; newy = oldy;  obj = 2;
            end
            if (obstacles(newx,newy) ==1)
                obj = 3;
                %newx = oldx; newy = oldy;
            end
            Qnext(1,action) = wt* Qvalues_norm(ysize*(oldx -1) + oldy,action)+...
                (1-wt)* Qvalues2(action,obj);
            
        end
        if (action == 4) % west
            if (oldy > 1)
                newx = oldx; newy = oldy-1; obj = 1;
            else
                newx = oldx; newy = oldy;  obj = 2;
            end
            if (obstacles(newx,newy) ==1)
                obj = 3;
                %newx = oldx; newy = oldy;
            end
            Qnext(1,action) = wt* Qvalues_norm(ysize*(oldx -1) + oldy,action)+...
                (1-wt)* Qvalues2(action,obj);
            
        end
%         if (obstacles(newx,newy) ==1)
%             obj = 3;
%             newx = oldx; newy = oldy;
%         end
              
    end
    dice = randi([1,10],1);
    move = find(Qnext==max(Qnext));
    if (dice == 1)
        action = randsample([1,2,3,4],1);
    else
        if (size(move,2) ==1)
           action = move;
        else
        action = randsample(move,1);
        end
    end
    
    num = ysize*(oldx -1) + oldy;
    Qvalues_norm(num,action) = (1 - alpha) * Qvalues_norm(num,action) + alpha*(rewards(num,action) + gamma*max(Qnext));
    DrawActionOnCell(action, oldx,oldy,xsize,ysize,.5);
    
%======if agent go to the dilemma, cross the obsatcles====
    if (num == num +3 || num ==num-1 || num == num +1 ||num == num - 1) 
       timeout = timeout +1;
    end
    if (timeout ==7)
        action = 2;
        timeout =0;
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
    oldx = newx; oldy = newy;
    if (obstacles(newx,newy) ==1)
       hitcount = hitcount +1;
    end
    
end






