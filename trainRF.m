 
function trainRF(trainFeat,trainLabel)
ntree=500;
mtry =floor(sqrt(size(trainFeat,2)));
extra_options.DEBUG_ON=1;
extra_options.nodesize = 5;
% extra_options.replace = 0 ;
model = classRF_train(trainFeat , trainLabel,ntree,mtry, extra_options);
 save('siftFV_node5_500tree_replace0.mat','model','-v7.3');