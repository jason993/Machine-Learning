function DrawActionOnCell(actionIndex, row, col, gridrows, gridcols, fontsize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

rotation = 0;
textToDraw = 'o';
switch actionIndex
   case 1 % north
       textToDraw = '\uparrow';
       rotation = 0;
   case 2 % south
       textToDraw = '\downarrow';
       rotation = 0;
   case 3 % east
       textToDraw = '\rightarrow';
       rotation = 0;
   case 4 % west
       textToDraw = '\leftarrow';
       rotation = 0;
%    case 5 % northeast 
%        textToDraw = '\rightarrow';
%        rotation = 45;
%    case 6 % southeast 
%        textToDraw = '\downarrow';
%        rotation = 45;
%    case 7 % southwest
%        textToDraw = '\leftarrow';
%        rotation = 45;
%    case 8 % northwest
%        textToDraw = '\uparrow';
%        rotation = 45;

   otherwise
      disp(sprintf('invalid action index: %d', actionIndex))
end
DrawTextOnCell(textToDraw, rotation,  row, col, gridrows, gridcols, fontsize);


function DrawTextOnCell(theText, rotation, row, col, gridrows, gridcols, fontsize)
[xc, yc] = FindCellCenter(row, col, gridrows, gridcols);
text(xc, yc, theText,  'FontSize', fontsize, 'Rotation', rotation);
end

function [x,y] = FindCellCenter(row, col, gridrows, gridcols)
xsp = 1 / (gridcols + 2);
ysp = 1 / (gridrows + 2);
x = ((2*col + 1) / 2) * xsp;
y = 1 - (((2*row + 1) / 2) * ysp);
x = x - xsp/5;
end

end

