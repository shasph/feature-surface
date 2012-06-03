function [x, y] = getEdge(Edge, a, b)
%   getEdge - return which row and line the edge [a b] lies on  
%
%   Copyright (c) 2012 Xiaochao Wang
%%
  [x, y] = find(Edge(:, 1) == a & ...
    Edge(:, 2) == b);
if isempty(x)
    [x, y] = find(Edge(:, 1) == b & ...
        Edge(:, 2) == a);
end