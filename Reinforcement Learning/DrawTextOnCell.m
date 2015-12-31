function DrawTextOnCell(theText, rotation, row, col, gridrows, gridcols, fontsize)
%DRAW Summary of this function goes here
%   Detailed explanation goes here
[xc, yc] = FindCellCenter(row, col, gridrows, gridcols);
text(xc, yc, theText,  'FontSize', fontsize, 'Rotation', rotation);

function [x,y] = FindCellCenter(row, col, gridrows, gridcols)
xsp = 1 / (gridcols + 2);
ysp = 1 / (gridrows + 2);
x = ((2*col + 1) / 2) * xsp;
y = 1 - (((2*row + 1) / 2) * ysp) - 0.01;
x = x - xsp/5;
end
end

