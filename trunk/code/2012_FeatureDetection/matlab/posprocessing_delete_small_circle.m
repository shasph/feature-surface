function Edge = posprocessing_delete_small_circle(Edge,D)
% posprocessing_delete_small_circle - delete small circles,
% deal with feature edges only when vertex valence degree is equal to two
%
%   Input:
%       - 'Edge'                : m*2 feature edge
%       - 'D'                   : data structure, contains following terms
%       -   'D.one_ring_vertex' : one ring vertices of a vertex
%       -   'D.one_ring_face'   : one ring faces of a vertex
%       -   'D.normal'          : vertex normal
%       -   'D.thgm'            : average lenth of the mesh edge
%       -   'D.nov'             : vertex size
%   Output:
%       - 'Edge'                : m*2 filtered feature edge
%
%   Copyright (c) 2012 Xiaochao Wang
%%
Feature_pNew = unique([Edge(:,1)' Edge(:,2)'] );
VfeatureDegree = ComputDegree(D, Feature_pNew, Edge);
% record the acessed vertex
HasDone = ones(length(Feature_pNew),1);

for i = 1:length(Feature_pNew)
    curV = Feature_pNew(i);
    % deal with unprocessing vertex only
    if HasDone(i)
        % for vertex with 2 neighbors
        if VfeatureDegree(i) == 2
            % record the length of feature line
            flag = 0;
            % record the whether teminate in a circal case
            Door = 0;
            RecordV = [];
            RecordV = [RecordV curV];
            % start vertex
            starV = curV;
            neig = getNeighbors(D, Feature_pNew, Edge, curV);
            
            if length(neig) ~= 2
                continue;
            else
                flag = flag + 1;
                nextV = neig(1);
                RecordV = [RecordV nextV];
                
                % recode the processed vertex
                Id = find(nextV==Feature_pNew);
                HasDone(Id) = 0;
                
                neig = getNeighbors(D, Feature_pNew, Edge, nextV);
                
                % iterative to find all circle edges
                while 1
                    if length(neig) ~= 2 || flag >= 8
                        break;
                    end
                    nextV = setdiff(neig,curV);
                    curV = RecordV(end);
                    RecordV = [RecordV nextV];
                    if  nextV == starV
                        Door = 1;
                        break;
                    end
                    % recode the processed vertex
                    Id = find(nextV==Feature_pNew);
                    HasDone(Id) = 0;
                    flag = flag + 1;
                    neig = getNeighbors(D, Feature_pNew, Edge, nextV);
                end
                
                % delete the circle edges
                if Door
                    for j = 1:length(RecordV) - 1
                        [x, y] = getEdge(Edge, RecordV(j), RecordV(j+1));
                        if ~isempty(x)
                            Edge(x, :) = [];
                        end
                    end
                end
            end
        end
    end
end