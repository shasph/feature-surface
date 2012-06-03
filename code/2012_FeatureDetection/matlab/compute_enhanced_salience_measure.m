function [Salience EHSalience LENTH] = compute_enhanced_salience_measure(V,F,D,PRIN,EVEN,Sharp_edge_v, Corner_v)
% compute_enhanced_salience_measure - salience computation
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
%       - 'EVEN' :              : even-value of each vertex
%       - 'PRIN'                : principal direction of each sharp edge vertex
%       - 'Sharp_edge_v'        : sharp edge feature vertex id
%       - 'Corner_v'            : corner feature vertex id
%
%   Output:
%       - 'Salience'            : salience measure before enhances
%       - 'EHSalience'          : salience measure after enhanced
%       - 'LENTH'               : the number of supporting neighbors
%
%   Copyright (c) 2012 Xiaochao Wang
%% initial salience measure
nofv = length(Sharp_edge_v);
Cn = ((EVEN(:,1) + EVEN(:,2) + EVEN(:,3))-1)/2;
% normalize the $E$ to [0 1]
Cn = Cn/max(Cn);
show_vertex_salience(V,F,-Cn);
%%
Salience = zeros(D.nov,1);
EHSalience = zeros(D.nov,1);
LENTH = zeros(D.nov,1); % record the lenth of the potential feature neighbors
%% used parameters
K = 40; % the maxmum steps
K1 = 5;  % maxmum number of principal points will be considered
thgm = D.thgm; % the distance similar weight in gaussian
thgm1 = 1.5;  % the weight to control the size of distance weight in gaussian
NST = 15*pi/180;% normal similar threshold is set, default value is 15 degree.

for j = 1:nofv
    i = Sharp_edge_v(j);
    v = V(i,:); % current location of v
    n_v = D.normal(i,:); % normal of vertex v
    v_ring_1 = D.one_ring_vertex{i};% one ring vertex index
    
    temp = intersect(v_ring_1, Sharp_edge_v);
    if isempty(temp)
        Salience(i) = abs(Cn(i));
        Salience1(i) = abs(Cn(i));
        continue;
    end
    v_r_1_c = V(v_ring_1,:);% one ring vertex coordinates
    v_ring_dest = v_r_1_c - repmat(v,length(v_ring_1),1)  ;% the vector from v to one ring vertices
    p_ring_1 = v_ring_dest - (v_ring_dest*n_v')*n_v ; % project the v_ring_dest at the tangent plane
    p_ring_1 = inv(diag(sqrt(sum(p_ring_1.^2,2))))*p_ring_1;
    p_c_m_d = PRIN(i,:); % the principal director based on the tensor
    
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
    
    % divide the temp into two group
    [Id1 Id2] = sort(temp);
    Energ = [0 0 0 0];
    Comb = zeros(4,2);
    Posi = zeros(4,2);
    cont = 1;
    for i1 = 1:2
        Fi = v_ring_1(Id2(i1));
        for j1 = 1:2
            Si = v_ring_1(Id2(end - j1 + 1));
            Posi(cont,:) = [Id2(i1) Id2(end - j1 + 1)];
            Comb(cont,:) = [Fi Si];
            Energ(cont) = p_ring_1(Posi(cont,1),:)*p_ring_1(Posi(cont,2),:)';
            cont = cont + 1;
        end
    end
    Id1 = []; Id2 =[];
    temp1 = [];
    temp1 = sort(abs(Energ));
    
    Energ = Energ.* abs(temp(Posi(:,1)).*temp(Posi(:,2)))';
    
    [Id1 Id2] = min(Energ);  t = abs(Id1); t = acos(t);
    
    NB = Posi(Id2,:);
    PS = Posi(Id2,:);
    %%
    for t1 = 1:2
        % put the active point into Front put the active point to the F_V_P if
        % it is a feature point
        t = [];
        % idex of the potential front point
        P_F_I = [];
        
        P_F_I = v_ring_1(NB(t1));
        % when the neigbour points is not a feature point, the intergral processing is terminate
        if ~belong_to(P_F_I, Sharp_edge_v) && ~belong_to(P_F_I, Corner_v)
            continue;
        end
        
        t = PRIN(i,:)*PRIN(P_F_I,:)';
        t = acos(t); % here t is the absolute angle of two lines
        if t > pi/2
            t = pi - t;
        end
        if ~belong_to(P_F_I, F_V_P) && (belong_to(P_F_I, Sharp_edge_v)|| belong_to(P_F_I, Corner_v)) & t<= NST
            % if belong to Corner_v, since it does not have the principal
            % direction, so it only put into F_V_P, not put into Front
            if belong_to(P_F_I, Corner_v)
                F_V_P = [F_V_P P_F_I];
            else
                Front = [ Front P_F_I];
                F_V_P = [F_V_P P_F_I];
            end
        end
    end
    %% Interactively find the neighbor points along principal curvature line
    % the number indicator
    conte = 0;
    while ~isempty(Front) && conte < K && length(F_V_P) < K1
        
        % the idex of the front point
        cvd = Front(1);
        v = V(cvd,:); % current location of v
        n_v = D.normal(cvd,:); % normal of vertex v
        v_ring_1 = D.one_ring_vertex{cvd};% one ring vertex index
        v_r_1_c = V(v_ring_1,:);% one ring vertex coordinates
        v_ring_dest = v_r_1_c - repmat(v,length(v_ring_1),1)  ;% the vector from v to one ring vertices
        p_ring_1 = v_ring_dest - (v_ring_dest*n_v')*n_v ; % project the v_ring_dest at the tangent plane
        p_ring_1 = inv(diag(sqrt(sum(p_ring_1.^2,2))))*p_ring_1;
        p_c_m_d = PRIN(cvd,:); % the principal director based on the tensor
        
        %% select the neighbor
        temp = [];
        Id1 = [];
        Id2 = [];
        temp = p_ring_1*p_c_m_d';
        
        % divide the temp into two group
        [Id1 Id2] = sort(temp);
        
        Energ = [0 0 0 0];
        Comb = zeros(4,2);
        Posi = zeros(4,2);
        cont = 1;
        for i1 = 1:2
            Fi = v_ring_1(Id2(i1));
            for j1 = 1:2
                Si = v_ring_1(Id2(end - j1 + 1));
                Posi(cont,:) = [Id2(i1) Id2(end - j1 + 1)];
                Comb(cont,:) = [Fi Si];
                Energ(cont) = p_ring_1(Posi(cont,1),:)*p_ring_1(Posi(cont,2),:)';
                cont = cont + 1;
            end
        end
        Id1 = []; Id2 =[];
        
        temp1 = [];
        temp1 = sort(abs(Energ));
        Energ = Energ.* abs(temp(Posi(:,1)).*temp(Posi(:,2)))';
        
        [Id1 Id2] = min(Energ); t = abs(Id1); t = acos(t);
        NB = Posi(Id2,:);
        PS = Posi(Id2,:);
        
        for t1 = 1:2
            % put the active point into Front put the active point to the F_V_P if the normal is similar
            t = [];
            % idex of the potential front point
            P_F_I = [];
            P_F_I = v_ring_1(NB(t1));
            if ~belong_to(P_F_I, Sharp_edge_v)&& ~belong_to(P_F_I, Corner_v)
                continue;
            end
            
            t = PRIN(cvd,:)*PRIN(P_F_I,:)';
            t = acos(t);
            if t > pi/2
                t = pi - t;
            end
            if ~belong_to(P_F_I, F_V_P) && (belong_to(P_F_I, Sharp_edge_v) || belong_to(P_F_I, Corner_v)) && t<= NST
                if belong_to(P_F_I, Corner_v)
                    F_V_P = [F_V_P P_F_I];
                else
                    Front = [ Front P_F_I];
                    F_V_P = [F_V_P P_F_I];
                end
            end
        end
        Front(1) = [];
        conte = conte + 1;
    end
    
    % should be summed with gaussian weigth
    dist1 = []; % the distance weights
    dist1 = sum((V(F_V_P,:) - repmat(V(i,:),length(F_V_P),1)).^2,2);
    t1 = sum(abs(Cn(F_V_P)).*exp((-dist1)./(2*thgm1*thgm*thgm1*thgm)));
    Salience(i) = t1;
    EHSalience(i) = t1;
    LENTH(i) = length(F_V_P);
    if length(F_V_P) > 3 && Cn(i) < 0.45 && mean(Cn(F_V_P))<0.45
        EHSalience(i) = t1*K1*exp(-Cn(i));
    end
end