function [Sharp_edge_v,Corner_v,EVEN,PRIN] = normal_tensor_voting(V,F,D,alpha,beta)
% normal tensor voting - initial feature detection.
%
%   Input:
%       - 'V'                   : a (n x 3) array vertex coordinates
%       - 'F'                   : a (m x 3) array faces
%       - 'D'                   : data structure, contains following terms
%       -   'D.one_ring_vertex' : one ring vertices of a vertex
%       -   'D.one_ring_face'   : one ring faces of a vertex
%       -   'D.normal'          : vertex normal
%       -   'D.thgm'            : average lenth of the mesh edge
%       -   'D.nov'             : vertex size
%       - 'alpha'               : parameter used in feature determination
%       - 'beta'                : parameter used in feature determination
%   Output:
%       - 'Sharp_edge_v'        : sharp edge feature vertex id
%       - 'Corner_v'            : corner feature vertex id
%       - 'EVEN' :              : even-value of each vertex
%       - 'PRIN'                : principal direction of each sharp edge vertex
%
% Reference:
%       (1) - Kim, H.S., Choi, H.K., Lee, K.H.. Feature detection of triangular meshes based on tensor voting theory.
%             Comput. Aided Des.41(1):47-58.
%       (2) - Wang, X.C., Cao, J.J., Liu, X.P., Li, B.J., Shi, X.Q., Sun, Y.Z. Feature detection on triangular
%             meshes via neighbor supporting. Journal of Zhejiang University-SCIENCE C, 2012, 13(6):440-451.
%
%   Copyright (c) 2012 Xiaochao Wang

%% Initalize the feature tank
Sharp_edge_v = [];
Face_v = [];
Corner_v = [];
% number of vertex
nov = D.nov;
% the even-value
EVEN =  zeros(size(V));
% the even-vector
EVTO = zeros(nov,9);
%% normal tensor computaton
for i = 1:nov
    % initialize the parameters
    v = V(i,:);% current vertex
    f = D.one_ring_face{i};% one ring faces of the current vertex
    weight = 0;% weitht
    Max_area = 0;% Maximum area among neighbor triangles
    T = zeros(3,3);% Tensor of the vertex v
    L = [];% eigen-value of tensor T
    e1 = [];e2 =[]; e3 = [];% eigen-vectors of corresponding eigen-values
    thta = 0;
    
    % compute the average length of edges in one ring
    nl = length(D.one_ring_vertex{i});
    thta  = max(sqrt(sum((repmat(v,nl,1)-V(D.one_ring_vertex{i},:)).^2,2)));
    % compute the area of one-ring faces
    area_face = [];
    % compute the area of one-ring faces
    for j = 1:length(f)
        vi = V(F(f(j),1),:);vj = V(F(f(j),2),:);vk = V(F(f(j),3),:);
        temp = cross(vi-vk,vi-vj);
        area_face(j) = 0.5*norm(temp);
    end
    Max_area = max(area_face);
    vi = V(F(f,1),:);vj = V(F(f,2),:);vk = V(F(f,3),:);
    % the baricenter of each face of one-ring face
    Center = (vi + vj + vk)/3;
    % the one ring face normal
    normalf = [];
    for j = 1:length(f)
        normalf(j,:) = cross( V(F(f(j),2),:)-V(F(f(j),1),:), V(F(f(j),3),:)-V(F(f(j),2),:));
        normalf(j,:) = normalf(j,:)/norm(normalf(j,:));
    end
    fn = normalf;
    
    % compute the formal tensor voting of vertex v
    for j = 1:length(f)
        weight = (area_face(j)/Max_area)*exp(-(norm(Center(j,:)-v)/thta));
        T = T + weight*fn(j,:)'*fn(j,:);
    end
    
    % apply eigen-analysis
    [Vec L] = eig(T);
    Li = diag(L);
    [Li,Id] = sort(Li,'descend');
    e1 = Vec(:,Id(1));
    e2 = Vec(:,Id(2));
    e3 = Vec(:,Id(3));
    
    % nomalize the even-values
    Li = Li/norm(Li);
    EVEN(i,:) = Li;
    EVTO(i,:) = [e1' e2' e3'];
end

%% Iterative adjust parameters to get pleasant result
while 1
    % initial feature classication
    PRIN = zeros(size(V));
    for i = 1:nov
        Li = EVEN(i,:);
        L1 = Li(1);L2 = Li(2);L3 = Li(3);
        if L3 < alpha
            if L2 < beta
                Face_v = [Face_v i];
            else
                Sharp_edge_v = [Sharp_edge_v i];
                % Each edge point has a principal direction
                PRIN(i,:)= cross(EVTO(i,1:3),EVTO(i,4:6));
            end
        else
            Corner_v = [Corner_v i];
        end
    end
    % show mesh and feature vertex
    show_feature_vertex(V,F,Sharp_edge_v, Corner_v);
    Door = input('Normal Tensor Voting -- The result is OK?  Input: y or n:--','s');
    if Door == 'y'|| Door == 'Y'
        break;
    else
        fprintf('The previous alpha is %f: ', alpha);
        alpha = input('Please input a new alpha: ');
        fprintf('The previous alpha is %f: ', beta);
        beta = input('Please input a new alpha: ');
        continue;
    end
end