function show_feature_line(V,F,Edge)
% show_feature_line - plot feature vertex and feature lines on 3D mesh.
%
%   show_feature_vertex(V,F,varargin)
%
%       - 'V' : a (n x 3) array vertex coordinates
%       - 'F' : a (m x 3) array faces
%       - 'Edge' : (k x 2) array feature edges
%
%   Copyright (c) 2012 Xiaochao Wang

if nargin<2 || nargin>3
    error('Not enough arguments.');
end

figure
plot_mesh(V,F);
hold on

% plot feature vertex and feature lines
Feature =unique([Edge(:,1)' Edge(:,2)']);
plot3(V(Feature,1),V(Feature,2),V(Feature,3),'r.');
for i = 1:size(Edge,1)
    Temp = Edge(i,:);
    plot3(V(Temp,1),V(Temp,2),V(Temp,3),'g'); hold on
end


