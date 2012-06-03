function neig = getNeighbors(D, FeatureSet, Edge, curV)
%   getNeighbors - get the adjacent feature vertex 
%
%   Input:
%       - 'D'                   : data structure, contains following terms
%       -   'D.one_ring_vertex' : one ring vertices of a vertex
%       -   'D.one_ring_face'   : one ring faces of a vertex
%       -   'D.normal'          : vertex normal
%       -   'D.thgm'            : average lenth of the mesh edge
%       -   'D.nov'             : vertex size
%       - 'Feature_pNew'        : id of feature vertex
%       - 'Edge'                : m*2 feature edge tank
%       - 'curV'                : current vertex id
%   Output:
%       - 'neig'                : adjacent feature vertex
%
%   Copyright (c) 2012 Xiaochao Wang
%%
neig = [];
interset = intersect(D.one_ring_vertex{curV}, FeatureSet);
for i = 1 : length(interset)
    [x, y] = getEdge(Edge, curV, interset(i));
    if ~isempty(x)
        neig = [neig, interset(i)];
    end
end