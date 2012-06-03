function bool = belong_to(u, X)
%   belong_to - determine whether element u belong to X 
%
%   if x belong to X, bool = 1, not bool = 0.
%
%   Copyright (c) 2012 Xiaochao Wang
%%
Id = find(u == X, 1);
if ~isempty(Id)
    bool = 1;
else 
    bool = 0;
end