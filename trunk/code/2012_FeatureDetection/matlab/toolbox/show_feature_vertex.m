function show_feature_vertex(V,F,varargin)
% show_feature_vertex - plot feature vertex on 3D mesh.
%
%   show_feature_vertex(V,F,varargin)
%
%       - 'V' : a (n x 3) array vertex coordinates
%       - 'F' : a (m x 3) array faces
%   'varargin' is a structure that may contains:
%       - 'Feature' : a (1 x t) array specifying the id of feature vertex.
%       - 'Sharp_edge_v' : a (1 x m) array specifying the id of sharp feature vertex.
%       - 'Corner_v' : a (1 x n) array specifying the id of corner vertex.
%       - 'vertex'
%
%
%   Copyright (c) 2012 Xiaochao Wang

if nargin<2
    error('Not enough arguments.');
end

optargin = size(varargin,2);

figure
plot_mesh(V,F);
hold on

% plot feature vertex
if optargin == 1
    Feature = varargin{1};
    plot3(V(Feature,1),V(Feature,2),V(Feature,3),'r.');
end

% plot sharp feature and corner vertex respectively
if optargin == 2
    Sharp_edge_v = varargin{1};
    plot3(V(Sharp_edge_v,1),V(Sharp_edge_v,2),V(Sharp_edge_v,3),'r.'); hold on;
    Corner_v = varargin{2};
    plot3(V(Corner_v,1),V(Corner_v,2),V(Corner_v,3),'g.');
end

