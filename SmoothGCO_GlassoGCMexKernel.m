function labels = SmoothGCO_GlassoGCMexKernel(scores, super_pixels, theta_edges, c, pair_wise, kernel)
lblCnt=size(scores,2);
% spCnt = length( unique(super_pixels));
spCnt = size(scores,1);


maxPenalty = 1000;

%  w = features{7} / mean(features{7}) ;


 maxPenalty =  1;
b = 1;
a = 4;
dataCost = maxPenalty * (1- 1./ (1+exp(-a*scores+b)));

% c=GetConnectivity(super_pixels);

lblCount = size(scores,2);
spCnt = size(scores,1);

 


%-----------scaling---------------

minTarget = 100;
minDataCost = minTarget;
for ls = 1:lblCnt
    minDataCost = min(minDataCost, min(dataCost(:,ls)));
end

multiplier =  max(1, minTarget/minDataCost);

%-----------------------------------------
kernel = kernel ./ max(kernel(:));

c = setEdgeWeight(super_pixels, features, spCnt,theta_edges);
 
 for i =1 : spCnt
     for j= 1:spCnt
         if (c(i,j) ~=0 && kernel(i,j)~=0)
             c(i,j)=  kernel(i,j);
         end
     end
 end
 
c=sparse(  triu( c)' +triu( c));
[nRows,nCols] = size(c);
c(1:(nRows+1):nRows*nCols) = 0;
% 

pair_cost = pair_wise  ;
[nRows,nCols] = size(pair_wise);
pair_cost(1:(nRows+1):nRows*nCols) = 0;
% % ------------

% % pair_cost = .5* (ones(lblCount)-eye(lblCount,lblCount));

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

[labels ENERGY ENERGYAFTER] =GCMex(Lin-1, single(dataCost'), c, single(pair_cost),0);





