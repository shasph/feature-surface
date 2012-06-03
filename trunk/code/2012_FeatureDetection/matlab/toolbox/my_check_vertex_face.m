function  [vertex,face] = my_check_vertex_face(vertex,face)
%  my_check_vertex_face - check and conver the matrix to n_by_m when n>=m
%
%   Copyright (c) 2012 Xiaochao Wang
if size(vertex,2)~=3
    vertex=vertex';
end
if size(face,2)~=3
    face=face';
end
