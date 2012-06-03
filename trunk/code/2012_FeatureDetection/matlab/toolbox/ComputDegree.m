function FeatureDegree = ComputDegree(D, FeatureSet, Edge)
%  ComputDegrees - compute the valence of each feature vertex
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
%   Output:
%       - 'FeatureDegree'       : the valence of each feature vertex
%
%   Copyright (c) 2012 Xiaochao Wang
%%
LenFea_pNew = length(FeatureSet);
FeatureDegree = [];
for i = 1 : LenFea_pNew
    curv = FeatureSet(i);
    m = 0;
    Neighborv = D.one_ring_vertex{curv};
    interNeig = intersect(FeatureSet, Neighborv);
    for j = 1 : length(interNeig)
        [x, y] = getEdge(Edge, curv, interNeig(j));
        if ~isempty(x)
            m = m + 1;
        end
    end
    %m = length(interNeig);
   FeatureDegree = [FeatureDegree; m];
end