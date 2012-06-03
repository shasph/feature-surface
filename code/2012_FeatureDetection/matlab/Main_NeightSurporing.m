% Feature detection on triangle meshes.
% According to :
%
%        - Wang, X.C., Cao, J.J., Liu, X.P., Li, B.J., Shi, X.Q., Sun, Y.Z. Feature detection on triangular
%           meshes via neighbor supporting. Journal of Zhejiang University-SCIENCE C, 2012, 13(6):440-451.
%
%   Copyright (c) 2012 Xiaochao Wang
%%
%% PART 0: Read mesh
%%
% Takes the Fandisk.off for example
clear,clc,close all

path(path,'toolbox');
% % filename = '../data/octa-flower.off';
filename = '../data/fandisk_noise.off';
name=filename((max(findstr(filename,'/'))+1):(max(findstr(filename,'.'))-1));
outputspace = ['../result/' name '/'];
if not(exist(outputspace))
    mkdir(outputspace);
end

% read mesh
[V,F] = read_mesh(filename);
[V,F] = my_check_vertex_face(V,F);

% Creat the half-edge data structure
Mifs = indexedfaceset(V,F);
M = halfedge(Mifs);
% one ring vertices of a vertex
D.one_ring_vertex = M.vertex_neighbors;
% one ring faces of a vertex
D.one_ring_face = compute_vertex_face_ring(F);
% compute the average lenth of the mesh edge
D.thgm = compute_average_length(V,F);
% compute vertex, face normal
[normal,normalf] = compute_normal(V,F);
D.normal = normal';
% vertex size
D.nov = size(V,1);
% show the mesh
figure
plot_mesh(V,F);

%%
%% PART 1: Detect the initial feature vertex based on normal tensor voting
%%
% parameters
alpha = 0.065;
beta = 0.020;
% normal tensor voting
[Sharp_edge_v,Corner_v,EVEN,PRIN] = normal_tensor_voting(V,F,D,alpha,beta);

% show mesh and feature vertex
show_feature_vertex(V,F,Sharp_edge_v, Corner_v);

%%
%% PART 2: Salience measure computation
%%
[Salience  EHSalience LENTH] = compute_enhanced_salience_measure(V,F,D,PRIN,EVEN,Sharp_edge_v, Corner_v);

% show the salience measure
TH = [];Id = []; Temp = [];
Temp = sort(Salience(Sharp_edge_v));
TH = Temp(floor(length(Temp)*0.80):end);
Salience(Corner_v) = mean(TH);
TH = [];Id = []; Temp = [];
Temp = sort(EHSalience(Sharp_edge_v));
TH = Temp(floor(length(Temp)*0.80):end);
EHSalience(Corner_v) = mean(TH);
% show the salience before enhanced
show_vertex_salience(V,F,-Salience);
% show the salience after enhances
show_vertex_salience(V,F,-EHSalience);

%% set threshold to filter the false feature points
temp = sort(EHSalience(Sharp_edge_v));
% temp = sort(Salience(Sharp_edge_v));
x = linspace(0,1,length(temp));
x = x';
figure;hold on
plot(x,temp,'r'); hold on

% interactive select threshold
while 1
    TH = input('Input a threshold based on salience measure:--');
    plot(x,repmat(TH,1,length(x)),'b');hold on
    Id = find(EHSalience(Sharp_edge_v) > TH);
    F_R_P = Sharp_edge_v(Id);
    
    % show feature vertex
    show_feature_vertex(V,F,F_R_P, Corner_v);
    
    Door = input('Filter Non Feature Vertex -- The result is OK? Input: y or n:--','s');
    if Door == 'y'|| Door == 'Y'
        break;
    else
        continue;
    end
end

%%
%% PART 3: Connect the feature point to feature line
%%
[Sharp_edge_v,Corner_v,Edge] = connect_feature_line(M,F_R_P,Corner_v);
% show feature lines
show_feature_line(V,F,Edge);

%%
%% PART 4: Filter the feature lines via edge measure (additional prunning process)
%%
% if we get optimal result through above code, the following processes can be not implemented.
noe = size(Edge,1);
% give privilege to corver
LENTH(Corner_v) = 5;
% compute a salience measure measure to each edge
ELENT = zeros(noe,1);
for i = 1: noe
    ELENT(i) = EHSalience(Edge(i,1))*EHSalience(Edge(i,2))*LENTH(Edge(i,1))*LENTH(Edge(i,2));
end

temp = sort(ELENT);
x = linspace(0,1,length(temp));
x = x';
figure;hold on
plot(x,temp,'r'); hold on

% interactive select threshold
while 1
    TH = input('Input a threshold based on edge strength:-- ');
    plot(x,repmat(TH,1,length(x)),'b');hold on
    Id = find(ELENT > TH);
    Edge1 = Edge(Id,:);
    
    % show feature lines
    show_feature_line(V,F,Edge1);
    
    Door = input('Filter Non Feature Edge -- The result is OK? Input: y or n:--','s');
    if Door == 'y'|| Door == 'Y'
        break;
    else
        continue;
    end
end
Edge = [];
Edge = Edge1;
%% Further filter extra feature edge via interactive manner

% deal with joint feature edges
Edge = postprocessing_filter_joints(V,F,Edge,D,Corner_v);
% show feature vertex
show_feature_line(V,F,Edge);

%%
%% PART 5: Prolong the existing featuares to get long and closed feature line (not included in artical)
%%
% parameters
min_k = 7;  % the smallest feature lines we want to preserv
max_k = 10; % the maxmum steps allowed to prolong

% old edge information
O_edge = Edge;
% Iterative adjust parameters to get pleasant result
while 1
% get close and prolonged feature edges
Edge = postprocessing_prolong_closed_feature(V,Edge,D,max_k,min_k);
% show feature lines
show_feature_line(V,F,Edge);
    Door = input('Prolong Feature Edge -- The result is OK?  Input: y or n:--','s');
    if Door == 'y'|| Door == 'Y'
        break;
    else
        fprintf('The previous max_k is %f: ', max_k);
        max_k = input('Please input a new alpha: ');
        fprintf('The previous min_k is %f: ', min_k);
        min_k = input('Please input a new alpha: ');
        Edge = O_edge;
        continue;
    end
end

%%
%% PART 6: Delete small circles
%%
% delte small circles
Edge = posprocessing_delete_small_circle(Edge,D);
% show feature lines
show_feature_line(V,F,Edge);

%%
%% PART 7: Save data
%%
cd(outputspace)
save FeatureDate V F Edge












