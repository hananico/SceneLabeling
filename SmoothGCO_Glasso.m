function labels = SmoothGCO_Glasso(scores, super_pixels, theta_edges, features, pair_wise)
lblCnt=size(scores,2);
% spCnt = length( unique(super_pixels));
spCnt = size(scores,1);


%-----------Datacost------------------------------------------------------

maxPenalty = 1000;
w = features{7} / mean(features{7}) ;

%  maxPenalty =  14;
b = 1;
a = 4;
dataCost = maxPenalty * (1- 1./ (1+exp(-a*scores+b)));

c=GetConnectivity(super_pixels);

lblCount = size(scores,2);
spCnt = size(scores,1);


%-----------scaling-----------------------------------------------------

minTarget = 100;
minDataCost = minTarget;
for ls = 1:lblCnt
    minDataCost = min(minDataCost, min(dataCost(:,ls)));
end

multiplier =  max(1, minTarget/minDataCost);

%------------------------------------------------------------------------
% c = setEdgeWeight(super_pixels, features, spCnt,theta_edges);
% c = theta_edges*5 +c;

c  =  theta_edges;
[nRows,nCols] = size(c);
c(1:(nRows+1):nRows*nCols) = 0;
c = (  triu(c)' +triu(c));
[nRows,nCols] = size(pair_wise);
pair_wise(1:(nRows+1):nRows*nCols) = 0;
% 
pair_wise = pair_wise*10;
pair_wise = triu(pair_wise)' +triu(pair_wise);
pair_cost = (pair_wise);
% --------------------------------------------------------------------------

%--- intial labeling--
current = 0;
Lin = zeros(spCnt ,1);
for sp = 1: spCnt
    [foo Lin(sp)] = min(dataCost(sp,:));
end
%-------------------------------------------------------------------------

numItt = 1;
Lout = cell(numItt,1);
Energy = zeros(size(Lout));

for i=1:numItt
    
    graph = GCO_Create(spCnt,lblCnt);
    GCO_SetVerbosity(graph,1)
   
    GCO_SetDataCost(graph,dataCost');
    
    
    GCO_SetSmoothCost(graph,pair_cost);
    GCO_SetNeighbors(graph,c);
    GCO_SetLabeling(graph,Lin);
    %     stemp = ceil(sparseSmooth);
    %     GCO_SetNeighbors(graph,stemp);
    %     GCO_SetLabeling(graph,Lin);
    %     GCO_SetLabelOrder(graph,1:numTotalLabs);%randperm(numTotalLabs))
    
    %     if(exist('flatlabelSubSets','var'))
    %         GCO_Expansion(graph);
    %     else
    %         %GCO_Expansion(graph)
    %         GCO_Swap(graph);
    %     end
    try
        GCO_Expansion(graph);
    catch
        GCO_Swap(graph,1000);
    end
    Lout{i} = GCO_GetLabeling(graph);
    Energy(i) = GCO_ComputeEnergy(graph);
    current = 0;
    GCO_Delete(graph);
end


[foo ndx]= min(Energy);


graph = GCO_Create(spCnt,lblCnt);
GCO_SetVerbosity(graph,0);
GCO_SetDataCost(graph,dataCost');

c2=GetConnectivity(super_pixels);

GCO_SetSmoothCost(graph,zeros(lblCnt,lblCnt));

GCO_SetNeighbors(graph,c2);
GCO_SetLabeling(graph,Lin);

GCO_Expansion(graph);

inEnergy = GCO_ComputeEnergy(graph);

lbls = GCO_GetLabeling(graph);

% if inEnergy <min(Energy)
%     labels = lbls;
% else
%     labels = Lout{ndx};
% end

labels = Lout{ndx};

% try
%      GCO_Expansion(graph);
% catch
%     GCO_Swap(graph);
% end
%
% labels= GCO_GetLabeling(graph);





























