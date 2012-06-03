function Edge = postprocessing_prolong_closed_feature(V,Edge,D,max_k,min_k)
% postprocessing_prolong_closed_feature - get close and prolonged feature edges,
% deal with feature edges only when vertex valence degree is equal to one
%
%   Input:
%       - 'Edge'                : m*2 feature edge
%       - 'D'                   : data structure, contains following terms
%       -   'D.one_ring_vertex' : one ring vertices of a vertex
%       -   'D.one_ring_face'   : one ring faces of a vertex
%       -   'D.normal'          : vertex normal
%       -   'D.thgm'            : average lenth of the mesh edge
%       -   'D.nov'             : vertex size
%       - 'max_k'               : maxmum steps allowed to prolong
%       - 'min_k'               : Smallest number of a feature curve
%   Output:
%       - 'Edge'                : m*2 filtered feature edge
%
% Reference:
%       (1) - Huang, H, and Ascher, U. Surface mesh smoothing, regularization and feature detection,
%             SIAM Journal of Scientific Computing, 31(1): 74-93.
%       (2) - Zhang, H.J., Gen, B., Wang, G.P.. Feature edge extraction method of triangle meshes
%             based on tensor voting theory. Journal of computer aided design & computer graphics, 2011, 23(1):62-70.
%   Copyright (c) 2012 Xiaochao Wang

% compute the valence of featur vertex
%%
Feature_pNew = unique([Edge(:,1)' Edge(:,2)']);
VfeatureDegree = ComputDegree(D, Feature_pNew, Edge);
[Id Idv]  = find(VfeatureDegree==1);

for i = 1:length(Id)
    % two cases
    Door1 = 0; % short line
    Door2 = 0; % long line
    RecordV = [];
    curV = Feature_pNew(Id(i));
    if VfeatureDegree(Id(i))~=1
        continue;
    end
    % record accessed vertex
    RecordV = [RecordV curV];
    % deal with leaf vertex
    neig = getNeighbors(D, Feature_pNew, Edge, curV);
    % find all neighbors connect to current feature vertex
    neig = setdiff(neig,curV);
    while 1
        
        % case1
        if isempty(neig) || belong_to(neig(1), Feature_pNew(Id))
            Door1 = 1;
            RecordV = [RecordV neig(1)];
            break;
        end
        
        % case2
        if length(RecordV) >= min_k + 5
            Door2 = 1;
            RecordV = [RecordV neig(1)];
            break;
        end
        
        RecordV = [RecordV neig(1)];
        neig = getNeighbors(D, Feature_pNew, Edge, neig(1));
        neig = setdiff(neig,RecordV(end-1) );
    end
    
    % one feature line has two leaves
    if Door1
        if length(RecordV) <= min_k
            % delete edges
            for j = 1:length(RecordV)-1
                [x, y] = getEdge(Edge, RecordV(j), RecordV(j+1));
                if ~isempty(x)
                    Edge(x, :) = [];
                end
            end
            % update the VfeatureDegree
            for j = 1:length(RecordV)
                Idt = find(RecordV(j)==Feature_pNew);
                VfeatureDegree(Idt) = 0;
            end
        else
            
            % need to extend the leaf to connect a potential feature vertex
            curV = RecordV(1); % current vertex id
            Idt = find(curV==Feature_pNew);
            if VfeatureDegree(Idt) == 1
                
                % principle direction
                p_c_m_d = V(RecordV(1),:) - V(RecordV(2),:);
                p_c_m_d = p_c_m_d/norm(p_c_m_d);
                Front = find_supporting_neighbors(V,curV, D,p_c_m_d,Feature_pNew,max_k);
                % update the feature Edge
                if ~isempty(Front)
                    Edge = [Edge; [Front(1:end-1);Front(2:end)]'];
                    
                    % update the VfeatureDegree (only two vertex need update)
                    Idt = find(Front(1)==Feature_pNew);
                    VfeatureDegree(Idt) = 2;
                    Idt = find(Front(end)==Feature_pNew);
                    VfeatureDegree(Idt) = 2;
                end
            end
            % the inverse direction
            curV = RecordV(end); % current vertex id
            Idt = find(curV==Feature_pNew);
            if VfeatureDegree(Idt) == 1
                % principle direction
                p_c_m_d = V(RecordV(end),:) - V(RecordV(end-1),:);
                p_c_m_d = p_c_m_d/norm(p_c_m_d);
                Front = find_supporting_neighbors(V,curV, D,p_c_m_d,Feature_pNew,max_k);
                % update the feature Edge
                if ~isempty(Front)
                    Edge = [Edge; [Front(1:end-1);Front(2:end)]'];
                    % update the VfeatureDegree (only two vertex need update)
                    Idt = find(Front(1)==Feature_pNew);
                    VfeatureDegree(Idt) = 2;
                    Idt = find(Front(end)==Feature_pNew);
                    VfeatureDegree(Idt) = 2;
                end
            end
        end
        
    end
    
    % along one direction
    if Door2
        % need to extend the leaf to connect a potential feature vertex
        curV = RecordV(1); % current vertex id
        % principle direction
        p_c_m_d = V(RecordV(1),:) - V(RecordV(2),:);
        p_c_m_d = p_c_m_d/norm(p_c_m_d);
        Front = find_supporting_neighbors(V,curV, D,p_c_m_d,Feature_pNew, max_k);
        % update the feature Edge
        if ~isempty(Front)
            Edge = [Edge; [Front(1:end-1);Front(2:end)]'];
            % update the VfeatureDegree (only two vertex need update)
            Idt = find(Front(1)==Feature_pNew);
            VfeatureDegree(Idt) = 2;
            Idt = find(Front(end)==Feature_pNew);
            VfeatureDegree(Idt) = 2;
        end
    end
end
