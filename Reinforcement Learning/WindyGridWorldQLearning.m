function WindyGridWorldQLearning()

    fprintf('WindyGridWorldQLearning\n'); 

    gamma = 0.9;
    alpha = 0.1;
    epsilon = 0.2;

    gridcols = 10; 
    gridrows = 7;
    windpowers = [0 0 0 0 1 1 2 2 1 1];
    fontsize = 16;
    showTitle = 1;

    episodeCount = 900;
    selectedEpisodes = [900];

    isKing = 1; 
    canHold = 0;

    start.row = 7;
    start.col = 1;
    goal.row = 1;
    goal.col = 1;

selectedEpIndex = 1;
 actionCount = 8; 

% initialize Q with zeros
Q = zeros(gridrows, gridcols, actionCount);

a = 0; % an invalid action
% loop through episodes
for ei = 1:episodeCount,
    %disp(sprintf('Running episode %d', ei));
    curpos = start;
    nextpos = start;

    %epsilon or greedy
    if(rand > epsilon) % greedy
        [qmax, a] = max(Q(curpos.row,curpos.col,:));
    else
        a = IntRand(1, actionCount);
    end

    while(PosCmp(curpos, goal) ~= 0)
        % take action a, observe r, and nextpos
        nextpos = GiveNextPos(curpos, a, windpowers, gridcols, gridrows);
        if(PosCmp(nextpos, goal) ~= 0), r = -1; else r = 10; end

        % choose a_next from nextpos
        [qmax, a_next] = max(Q(nextpos.row,nextpos.col,:));
        if(rand <= epsilon) % explore
            a_next = IntRand(1, actionCount);
        end

        % update Q:
        curQ = Q(curpos.row, curpos.col, a);
        nextQ = qmax; %Q(nextpos.row, nextpos.col, a_next);
        Q(curpos.row, curpos.col, a) = curQ + alpha*(r + gamma*nextQ - curQ);

        curpos = nextpos; a = a_next;
    end % states in each episode

    % if the current state of the world is going to be drawn ...
    if(selectedEpIndex <= length(selectedEpisodes) && ei == selectedEpisodes(selectedEpIndex))
        curpos = start;
        rows = []; cols = []; acts = [];
        for i = 1:(gridrows + gridcols) * 10,
            [qmax, a] = max(Q(curpos.row,curpos.col,:));
            nextpos = GiveNextPos(curpos, a, windpowers, gridcols, gridrows);
            rows = [rows curpos.row];
            cols = [cols curpos.col];
            acts = [acts a];

            if(PosCmp(nextpos, goal) == 0), break; end
            curpos = nextpos;
        end % states in each episode

        %figure;
        figure('Name',sprintf('Episode: %d', ei), 'NumberTitle','off');
        DrawWindyEpisodeState(rows, cols, acts, start.row, start.col, goal.row, goal.col, windpowers, gridrows, gridcols, fontsize);
        if(showTitle == 1),
            title(sprintf('Windy grid-world SARSA - episode %d - (\\epsilon: %3.3f), (\\alpha = %3.4f), (\\gamma = %1.1f)', ei, epsilon, alpha, gamma));
        end

        selectedEpIndex = selectedEpIndex + 1;
    end

end % episodes loop

function c = PosCmp(pos1, pos2)
c = pos1.row - pos2.row;
if(c == 0)
    c = c + pos1.col - pos2.col;
end

function nextPos = GiveNextPos(curPos, actionIndex, windpowers, gridCols, gridRows)
nextPos = curPos;
switch actionIndex
   case 1 % east
       nextPos.col = curPos.col + 1;
   case 2 % south
       nextPos.row = curPos.row + 1;       
       if(nextPos.row ==4 && nextPos.col <= 4 )   nextPos.row = curPos.row;  end     
   case 3 % west
       nextPos.col = curPos.col - 1;
       if(nextPos.row ==4 && nextPos.col <= 4 )   nextPos.col = curPos.col;  end 
   case 4 % north
       nextPos.row = curPos.row - 1;
       if(nextPos.row ==4 && nextPos.col <= 4 )   nextPos.row = curPos.row;  end 
   case 5 % northeast 
       nextPos.col = curPos.col + 1;
       nextPos.row = curPos.row - 1;
       if(nextPos.row ==4 && nextPos.col <= 4 )   nextPos.row = curPos.row;  end 
   case 6 % southeast 
       nextPos.col = curPos.col + 1;
       nextPos.row = curPos.row + 1;
       if(nextPos.row ==4 && nextPos.col <= 4 )   nextPos.row = curPos.row;  end 
   case 7 % southwest
       nextPos.col = curPos.col - 1;
       nextPos.row = curPos.row + 1;
       if(nextPos.row ==4 && nextPos.col <= 4 )   nextPos.row = curPos.row;  end 
   case 8 % northwest
       nextPos.col = curPos.col - 1;
       nextPos.row = curPos.row - 1;
       if(nextPos.row ==4 && nextPos.col <= 4 )   nextPos.row = curPos.row;  end 
   case 9 % hold
       nextPos = curPos;
   otherwise
      disp(sprintf('invalid action index: %d', actionIndex))
end

if(curPos.col > 4)    
    nextPos.row = nextPos.row - windpowers(nextPos.col);
    nextPos.col = nextPos.col - windpowers(nextPos.col);
end



if(nextPos.col <= 0), nextPos.col = 1; end
if(nextPos.col > gridCols), nextPos.col = gridCols; end

if(nextPos.row <= 0), nextPos.row = 1; end
if(nextPos.row > gridRows), nextPos.row = gridRows; end




function n = IntRand(lowerBound, upperBound)
n = floor((upperBound - lowerBound) * rand + lowerBound);




function DrawWindyEpisodeState(rows, cols, acts, SRow, SCol, GRow, GCol, windpowers, gridrows, gridcols, fontsize)
DrawGrid(gridrows, gridcols);
DrawTextOnCell('S', 0, SRow, SCol, gridrows, gridcols, fontsize);
DrawTextOnCell('G', 0, GRow, GCol, gridrows, gridcols, fontsize);

for i=1:length(rows),
    DrawActionOnCell(acts(i), rows(i), cols(i), gridrows, gridcols, fontsize);
end

for i=1:gridcols,
    [xc, yc] = FindColBaseCenter(i, gridrows, gridcols);
    text(xc, yc, sprintf('%d',windpowers(i)), 'FontSize', fontsize, 'Rotation', 0);
end



function DrawEpisodeState(rows, cols, acts, SRow, SCol, GRow, GCol, gridrows, gridcols, fontsize)
DrawGrid(gridrows, gridcols);
DrawTextOnCell('S', 0, SRow, SCol, gridrows, gridcols, fontsize);
DrawTextOnCell('G', 0, GRow, GCol, gridrows, gridcols, fontsize);

for i=1:length(rows),
    DrawActionOnCell(acts(i), rows(i), cols(i), gridrows, gridcols, fontsize);
end



function DrawGrid(gridrows, gridcols)
xsp = 1 / (gridcols + 2);
ysp = 1 / (gridrows + 2);

x = zeros(1, 2*(gridcols + 1));
y = zeros(1, 2*(gridcols + 1));
i = 1;
for xi = xsp:xsp:1 - xsp,
    x(2*i - 1) = xi; x(2*i) = xi;
    if(mod(i , 2) == 0)
        y(2*i - 1) = ysp;y(2*i) = 1-ysp;
    else
        y(2*i - 1) = 1 - ysp;y(2*i) = ysp;
    end
    i = i + 1;
end

x2 = zeros(1, 2*(gridrows + 1));
y2 = zeros(1, 2*(gridrows + 1));
i = 1;
for yi = ysp:ysp:1 - ysp,
    y2(2*i - 1) = yi; y2(2*i) = yi;
    if(mod(i , 2) == 0)
        x2(2*i - 1) = xsp;x2(2*i) = 1-xsp;
    else
        x2(2*i - 1) = 1 - xsp;x2(2*i) = xsp;
    end
    i = i + 1;
end

plot(x, y, '-');
hold on
plot(x2, y2, '-');
axis([0 1 0 1]);
axis off
set(gcf, 'color', 'white');



function DrawTextOnCell(theText, rotation, row, col, gridrows, gridcols, fontsize)
[xc, yc] = FindCellCenter(row, col, gridrows, gridcols);
text(xc, yc, theText,  'FontSize', fontsize, 'Rotation', rotation);







function DrawActionOnCell(actionIndex, row, col, gridrows, gridcols, fontsize)
rotation = 0;
textToDraw = 'o';
switch actionIndex
   case 1 % east
       textToDraw = '\rightarrow';
       rotation = 0;
   case 2 % south
       textToDraw = '\downarrow';
       rotation = 0;
   case 3 % west
       textToDraw = '\leftarrow';
       rotation = 0;
   case 4 % north
       textToDraw = '\uparrow';
       rotation = 0;
   case 5 % northeast 
       textToDraw = '\rightarrow';
       rotation = 45;
   case 6 % southeast 
       textToDraw = '\downarrow';
       rotation = 45;
   case 7 % southwest
       textToDraw = '\leftarrow';
       rotation = 45;
   case 8 % northwest
       textToDraw = '\uparrow';
       rotation = 45;

   otherwise
      disp(sprintf('invalid action index: %d', actionIndex))
end
DrawTextOnCell(textToDraw, rotation,  row, col, gridrows, gridcols, fontsize);




function [x,y] = FindCellCenter(row, col, gridrows, gridcols)
xsp = 1 / (gridcols + 2);
ysp = 1 / (gridrows + 2);
x = ((2*col + 1) / 2) * xsp;
y = 1 - (((2*row + 1) / 2) * ysp);
x = x - xsp/5;



function [x,y] = FindColBaseCenter(col, gridrows, gridcols)
row = gridrows + 1;
xsp = 1 / (gridcols + 2);
ysp = 1 / (gridrows + 2);
x = ((2*col + 1) / 2) * xsp;
y = 1 - (((2*row + 1) / 2) * ysp);
x = x - xsp/5;