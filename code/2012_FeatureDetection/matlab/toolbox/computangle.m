function angle = computangle(a, b)
%  computangle - compute the angle of two vectors a and b
%
%   Copyright (c) 2012 Xiaochao Wang
%%
l1 = norm(a);
l2 = norm(b);
l = a * b';
angle = acos(l / (l1 * l2));