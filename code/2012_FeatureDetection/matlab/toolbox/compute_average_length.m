function lenth = compute_average_length(V,F)
% compute_average_length - compute the average length of a mesh
%
% Input:   
%         V,F are the vertex and face of a mesh.
% Output:   
%         lenth is the average length of a mesh
%
%   Copyright (c) 2012 Xiaochao Wang
%%
[V,F] = my_check_vertex_face(V,F);
i = [F(:,1);F(:,2);F(:,3)];
j = [F(:,2);F(:,3);F(:,1)];
A = sparse(i,j,1); 
[i,j] = find(A);     % direct link
d = sqrt(sum((V(i,:) - V(j,:)).^2,2));
lenth = sum(d)/length(d);
