function show_vertex_salience(V,F,Salience)
% show_show_vertex_salience - plot salience of vertex on 3D mesh.
%
%   show_vertex_salience(V,F,Salience)
%
%       - 'V' : a (n x 3) array vertex coordinates
%       - 'F' : a (m x 3) array faces
%       - 'Salience' : (n x 1) array scalar salience value of each vertex
%
%   Copyright (c) 2012 Xiaochao Wang

if nargin<2 || nargin>3
    error('Not enough arguments.');
end

% plot salience of mesh
options.face_vertex_color = Salience;
figure
plot_mesh(V,F,options);
colormap(jet);
colorbar;




