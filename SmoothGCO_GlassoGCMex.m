function labels = SmoothGCO_GlassoGCMex(scores, super_pixels, theta_edges, features, pair_wise, kernel)
lblCnt=size(scores,2);
% spCnt = length( unique(super_pixels));
spCnt = size(scores,1);


maxPenalty = 1000;
b = 0;
a = 0.5;



 w = features{7} / mean(features{7}) ;
 
 dataCost = maxPenalty *( -log( 1./ (1+exp(-scores))));
%  dataCost = maxPenalty * (1- 1./ (1+exp(-a*scores)));
 
%  dataCost = bsxfun(@times,dataCost,w');
 
% neighbours=findNeighbors(super_pixels);
% GCO_SetNeighbors(graph,neighbours);
c=GetConnectivity(super_pixels);

lblCount = size(scores,2);
spCnt = size(scores,1);

 
weight = 1
color_mean = features{10}';
for i=1:spCnt
    for j=1:spCnt
        if c(i,j)~=0
            c(i,j)=weight/(1+norm( color_mean(i,:)-color_mean(j,:)));
        end
    end
end


%-----------scaling---------------

minTarget = 100;
minDataCost = minTarget;
for ls = 1:lblCnt
    minDataCost = min(minDataCost, min(dataCost(:,ls)));
end

multiplier =  max(1, minTarget/minDataCost);

%-----------------------------------------

% c = theta_edges*5 +c;

c = setEdgeWeight(super_pixels, features, spCnt,theta_edges);
 
 c =sparse(  triu(c)' +triu(c));
[nRows,nCols] = size(pair_wise);
pair_wise(1:(nRows+1):nRows*nCols) = 0;

pair_wise = pair_wise*200;
pair_wise = triu(pair_wise)' +triu(pair_wise);
pair_cost = (pair_wise);
% ------------

% % pair_cost = 200* (ones(lblCount)-eye(lblCount,lblCount));

%--- intial labeling--
current = 0;
Lin = zeros(spCnt ,1);
for sp = 1: spCnt
    [foo Lin(sp)] = min(dataCost(sp,:));
end
%-------------------




numItt = 1;
Lout = cell(numItt,1);
Energy = zeros(size(Lout));

[labels ENERGY ENERGYAFTER] =GCMex(Lin, single(dataCost'), c, single(pair_cost),0);

% for i=1:numItt
%     
%     graph = GCO_Create(spCnt,lblCnt);
%     GCO_SetVerbosity(graph,1)
%     %     current = 0;
%     %     for ls = 1:numLabelSets
%     %         numL = size(dataInt{ls},1);
%     %         dataIntTmp{ls} = (dataInt{ls} + int32(coDataCost{ls}'))./2;
%     %         for l = 1:numL
%     %             GCO_SetDataCost(graph,int32([(ls-1)*numSP+1:numSP*(ls); dataIntTmp{ls}(l,1:numSP)]),l+current);
%     %         end
%     %         current = current+numL;
%     %     end
%     %     if(exist('flatlabelSubSets','var'))
%     %         for j = 1:length(flatlabelSubSets)
%     %             GCO_SetLabelCost(graph,params.labelSubSetsWeight,flatlabelSubSets{j})
%     %         end
%     %     end
%     
%     GCO_SetDataCost(graph,dataCost');
%     
%     
%     GCO_SetSmoothCost(graph,pair_cost);
%     GCO_SetNeighbors(graph,c);
%     GCO_SetLabeling(graph,Lin);
%     %     stemp = ceil(sparseSmooth);
%     %     GCO_SetNeighbors(graph,stemp);
%     %     GCO_SetLabeling(graph,Lin);
%     %     GCO_SetLabelOrder(graph,1:numTotalLabs);%randperm(numTotalLabs))
%     
%     %     if(exist('flatlabelSubSets','var'))
%     %         GCO_Expansion(graph);
%     %     else
%     %         %GCO_Expansion(graph)
%     %         GCO_Swap(graph);
%     %     end
%     try
%         GCO_Expansion(graph);
%     catch
%         GCO_Swap(graph,1000);
%     end
%     Lout{i} = GCO_GetLabeling(graph);
%     Energy(i) = GCO_ComputeEnergy(graph);
%     current = 0;
%     GCO_Delete(graph);
% end

% 
% [foo ndx]= min(Energy);


% % graph = GCO_Create(spCnt,lblCnt);
% % GCO_SetVerbosity(graph,0);
% % GCO_SetDataCost(graph,dataCost');
% % 
% % c2=GetConnectivity(super_pixels);
% % 
% % GCO_SetSmoothCost(graph,zeros(lblCnt,lblCnt));
% % 
% % GCO_SetNeighbors(graph,c2);
% % GCO_SetLabeling(graph,Lin);
% % 
% % GCO_Expansion(graph);
% % 
% % inEnergy = GCO_ComputeEnergy(graph);
% % 
% % lbls = GCO_GetLabeling(graph);
% % 
% % % if inEnergy <min(Energy)
% % %     labels = lbls;
% % % else
% % %     labels = Lout{ndx};
% % % end
% % 
% % labels = Lout{ndx};

% try
%      GCO_Expansion(graph);
% catch
%     GCO_Swap(graph);
% end
%
% labels= GCO_GetLabeling(graph);



