function [Sharp_edge_v,Corner_v,Edge] = connect_feature_line(M,F_R_P,Corner_v)
% connect_feature_line - connect feature vertex to feature lines
%
%   Input:
%       - 'M'                   : half-edge data structure of the mesh
%       - 'F_R_P'               : id of feature vertex
%       - 'Corner_v'            : corner feature vertex id
%   Output:
%       - 'Sharp_edge_v'        : sharp edge feature vertex id
%       - 'Corner_v'            : corner feature vertex id
%       - 'Edge'                : m*2 feature edges
%
% Reference:
%       (1) - Ohtake, Y., Belyaev, A., Seidel,H.P.. Ridge-valley lines on meshes via implicit surface fitting.
%             ACM Trans. Graph.,23(3):609-612.
%       (2) - Wang, X.C., Cao, J.J., Liu, X.P., Li, B.J., Shi, X.Q., Sun, Y.Z. Feature detection on triangular
%             meshes via neighbor supporting. Journal of Zhejiang University-SCIENCE C, 2012, 13(6):440-451.
%
%   Copyright (c) 2012 Xiaochao Wang
%%
Sharp_edge_v = F_R_P;
Feature_p = [ Corner_v Sharp_edge_v];% put the sharpe edge points and corner points togother
nse = length(Feature_p);
Labled = [];
Edge = [];% n*2, storage the connection information of feature line
Isolated = []; % storage the isolated points
for i = 1:nse
    v = Feature_p(i);
    Labled = [Labled v];
    v_r = M.vertex_orig_edges(v);% the half edge from vertex i
    cont = 0;
    for j = 1:length(v_r)
        vd = M.edge_dest(v_r(j));% the vertex share a common edge with vertex i
        if belong_to(vd,Feature_p)
            cont = cont - 1;
        end
        if belong_to(vd,Feature_p)&&~belong_to(vd,Labled)
            % corner vertex has priority connect to neighbors
            if belong_to(v,Corner_v)
                Edge = [Edge; v vd];
                continue;
            end
            % consider the third vertex
            e_n = M.edge_next(v_r(j)); % the next edge of vd
            vn = M.edge_dest(e_n); % the end vertex of e_n
            % the three vertices of one face are all feature points
            if  ~belong_to(vn,Corner_v)
                % consider the oposite triangle
                e_n = M.edge_prev(M.edge_twin(v_r(j))); % the prev edge of twin of v_r(j)
                vn_p = M.edge_orig(e_n); % the orig vertex of e_n
                if ~belong_to(vn_p,Corner_v)
                    Edge = [Edge;v vd];% creat the connectiong of the feature vertices
                end
            end
        end
        cont = cont +1;
    end
    % if no vertex of its one ring connecting to it, it is a iisolated points
    if cont == length(v_r)
        Isolated = [Isolated v];
    end
end

% delete isolated feature vertex
if ~isempty(Isolated)
    Id = [];
    Id = intersect(1:length(Corner_v),Isolated);
    Corner_v(Id) = [];Id = [];
    Id = intersect(length(Corner_v)+1:length(Sharp_edge_v),Isolated);
    Corner_v(Id) = [];
end