function Edge = postprocessing_filter_joints(V,F,Edge,D,Corner_v)
% postprocessing_filter_joints - deal with feature edges joining, only when
% vertex valence degree bigger than two
%
%   Input:
%       - 'V'                   : a (n x 3) array vertex coordinates
%       - 'F'                   : a (m x 3) array faces
%       - 'Edge'                : m*2 feature edge
%       - 'D'                   : data structure, contains following terms
%       -   'D.one_ring_vertex' : one ring vertices of a vertex
%       -   'D.one_ring_face'   : one ring faces of a vertex
%       -   'D.normal'          : vertex normal
%       -   'D.thgm'            : average lenth of the mesh edge
%       -   'D.nov'             : vertex size
%       - 'Corner_v'            : corner vertex id
%   Output:
%       - 'Edge'                : m*2 filtered feature edge
%
%   Copyright (c) 2012 Xiaochao Wang
%%
Feature_pNew = unique([Edge(:,1)' Edge(:,2)'] );

% compute the valence of each featur vertex
VfeatureDegree = ComputDegree(D, Feature_pNew, Edge);

% using the angle between two feature edge to filter some edges
for i = 1:length(Feature_pNew)
    maxangle = 0.0;
    vector = [];
    mainv = [];
    % deal with joint cases
    if ~belong_to(Feature_pNew(i), Corner_v) && VfeatureDegree(i) >= 3
        newV = Feature_pNew(i);
        neig = getNeighbors(D, Feature_pNew, Edge, newV);
        vector = V(neig, :) - repmat(V(Feature_pNew(i), :),length(neig),1);
        [x, y] = size(vector);
        for j = 1:x
            for k = j+1:x
                angle = computangle(vector(j, :), vector(k, :));
                % preserving the feature vertex with largest edge angle
                if angle > maxangle
                    maxangle = angle;
                    mainv(1) = neig(j);
                    mainv(2) = neig(k);
                end
            end
        end
        exclude = setdiff(neig, mainv);
        for j = 1:length(exclude)
            [x, y] = getEdge(Edge, Feature_pNew(i), exclude(j));
            if ~isempty(x)
                % determine whether it is need to be deleted. using Door
                % and if end, you can determine whether it is need to be
                % deleted by youself
                
                % show feature lines
                
                %                 show_feature_line(V,F,Edge(x,:));
                %                 Door = input('delete this edge or not? input: 1 or 0');
                %                 if Door
                Edge(x, :) = [];
                %                 end
            end
        end
    end
end