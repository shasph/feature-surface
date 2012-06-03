%% delete circles
Feature_pNew = unique([Edge1(:,1)' Edge1(:,2)'] );
VfeatureDegree = ComputDegree(M, Feature_pNew, Edge1);
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
            neig = getNeighbors(M, Feature_pNew, Edge1, curV);
            
            if length(neig) ~= 2
                continue;
            else
                flag = flag + 1;
                nextV = neig(1);
                RecordV = [RecordV nextV];
                
                % recode the processed vertex
                Id = find(nextV==Feature_pNew);
                HasDone(Id) = 0;
                
                neig = getNeighbors(M, Feature_pNew, Edge1, nextV);
                
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
                    neig = getNeighbors(M, Feature_pNew, Edge1, nextV);
                end
                
                % delete the circle edges
                if Door
                    for j = 1:length(RecordV) - 1
                        [x, y] = getEdge(Edge1, RecordV(j), RecordV(j+1));
                        if ~isempty(x)
                            Edge1(x, :) = [];
                        end
                    end
                end
            end
        end
        
    end
end
% show feature lines
fun = zeros(size(V,1),1) + 0.2;
vertexStart = V(Edge1(:,1),:);
vertexEnd = V(Edge1(:,2),:);
lineColor = zeros(size(Edge1,1),3);
lineColor(:,1 ) = 1;
lineWidth = 4*ones(size(Edge1,1),1);
showLine(V,F,fun,vertexStart,vertexEnd,lineColor,lineWidth);