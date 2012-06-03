function F_V_P = find_supporting_neighbors(V,i,D,p_c_m_d,Feature_pNew,max_k )
% find_supporting_neighbors - get the connecting feature vertex
%
%   Input:
%       - 'V'                   : mesh vertex
%       - 'i'                   : id of current veretx
%       - 'D'                   : data structure, contains following terms
%       -   'D.one_ring_vertex' : one ring vertices of a vertex
%       -   'D.one_ring_face'   : one ring faces of a vertex
%       -   'D.normal'          : vertex normal
%       -   'D.thgm'            : average lenth of the mesh edge
%       -   'D.nov'             : vertex size
%       - 'p_c_m_d'             : principle direction
%       - 'Feature_pNew'        : id of feature vertex
%       - 'max_k'               : maxmum steps allowed to prolong
%   Output:
%       - 'F_V_R'               : id of searched feature vertex
%
% Reference:
%       (1) - Huang, H, and Ascher, U. Surface mesh smoothing, regularization and feature detection,
%             SIAM Journal of Scientific Computing, 31(1): 74-93.
%       (2) - Zhang, H.J., Gen, B., Wang, G.P.. Feature edge extraction method of triangle meshes
%             based on tensor voting theory. Journal of computer aided design & computer graphics, 2011, 23(1):62-70.
%   Copyright (c) 2012 Xiaochao Wang
%% used parameters
K = 40; % the maxmum steps
K1 = max_k;% maxmum number of principal points will be considered
Door = 0;

v = V(i,:); % current location of v
n_v =  D.normal(i,:); % normal of vertex v
v_ring_1 = D.one_ring_vertex{i};% one ring vertex index


v_r_1_c = V(v_ring_1,:);% one ring vertex coordinates
v_ring_dest = v_r_1_c - repmat(v,length(v_ring_1),1);% the vector from one ring vertices to v
p_ring_1 = v_ring_dest - (v_ring_dest*n_v')*n_v ; % project the v_ring_dest at the tangent plane
p_ring_1 = inv(diag(sqrt(sum(p_ring_1.^2,2))))*p_ring_1;

%% First decide wether the two neighbor points along the principal lines

% the active front of along the principal curvature line
Front = [];
% containing all the vertices along the principal curvature lines
F_V_P = [];
F_V_P = [F_V_P i];
%% select the neighbor
temp = [];
Id1 = [];
Id2 = [];
temp = p_ring_1*p_c_m_d';

% find the vertex in principle direction
[Id1 Id2] = max(temp);
F_V_P = [F_V_P v_ring_1(Id2)];
Front = v_ring_1(Id2);
%% Interactively find the neighbor points along principal curvature line
% the number indicator
conte = 0;
while ~isempty(Front) & conte < K & length(F_V_P) < K1
    
    % the idex of the front point
    cvd = Front(1);
    v = V(cvd,:); % current location of v
    n_v = D.normal(cvd,:); % normal of vertex v
    v_ring_1 = D.one_ring_vertex{cvd};% one ring vertex index
    v_r_1_c = V(v_ring_1,:);% one ring vertex coordinates
    v_ring_dest =  v_r_1_c - repmat(v,length(v_ring_1),1);% the vector from v to one ring vertices
    p_ring_1 = v_ring_dest - (v_ring_dest*n_v')*n_v ; % project the v_ring_dest at the tangent plane
    p_ring_1 = inv(diag(sqrt(sum(p_ring_1.^2,2))))*p_ring_1;
    p_c_m_d = V(F_V_P(end),:) - V(F_V_P(end-1),:); % the principal director based on the tensor
    p_c_m_d = p_c_m_d/norm(p_c_m_d);
    %% select the neighbor
    temp = [];
    Id1 = [];
    Id2 = [];
    temp = p_ring_1*p_c_m_d';
    
    % find the vertex in principle direction
    [Id1 Id2] = max(temp);
    F_V_P = [F_V_P v_ring_1(Id2)];
    Front = v_ring_1(Id2);
    
    % if connect to a feature vertex, stop the process
    if belong_to(Front,Feature_pNew)
        Front(1) = [];
        Door = 1;
        break;
    end
    conte = conte + 1;
end

if ~Door
    F_V_P = [];
end








