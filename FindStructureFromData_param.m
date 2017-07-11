function [classes , labels] = FindStructureFromData_param( M ,image_dir, desc_dir, ground_dir, sp_dir, model_smalltrees , covsel_param  )


% model_smalltrees : trained randomforest model
% M: image variable matrix
% [w, theta, iter, avgTol, hasError] =GraphicalLasso(center_norm,.001);

%ground_dir: Ground truth dir
% sp_dir: segments directory from adaptnn
% desc_dir: segments features directory from adaptnn

%  covsel_param : rho,alpha,beta,maxiter, freqprint,eps


% get Sp's feat

files = importdata(testSplitFile);

out_put_dir = './output/';

for i=1:size(files,1)
    
    testFileNames{i} = strrep(files{i},'/','_');
    
end


descFiles = dir([desc_dir '/*.mat']);

scaleV = 500;
featSize = 2330;
labelCnt = 23;

mmean = mean(M);
z=bsxfun(@minus,M,mmean);
z = z /(std(z(:)));

%first method for lables intractions
[Theta,obj,gap,iter,time] = smoothcovsel_solver(cov(z),covsel_param.rho,covsel_param.alpha,covsel_param.beta,...
    covsel_param.maxiter,covsel_param.freqprint,covsel_param.eps);
[nRows,nCols] = size(Theta);
Theta(1:(nRows+1):nRows*nCols) = 0;
pair_wise =  (1./(1+exp(-Theta)));

% second method for labels interactions 
[w, theta, iter, avgTol, hasError] =GraphicalLasso(z,.05);
w(1:(nRows+1):nRows*nCols) = 0;
Theta_norm  = w - min(w(:));
Theta_norm = Theta_norm ./ max(Theta_norm(:)) ; % *



% eps = 1;
% gamma=1;
% pair_wise = (eps + exp (gamma*Theta)) / (eps+1);


for i=1:size(descFiles)
    
    imgName=[desc_dir descFiles(i).name];
    inds=findstr(imgName,'/');
    imageName=imgName(inds(end)+1:end-4);
    [x y] = ind2sub(size(testFileNames),find(cellfun(@(x)strcmp(x,imageName),testFileNames)));
    
    if x==1
        gt_filename = strrep([ground_dir, imageName, '_GT.bmp'], '_sig.mat','');
        gt_s_3d= imread(gt_filename);
        
        img = imread([image_dir ,imageName ,'.bmp']);
        
        load([desc_dir , imageName]);
        [Theta,obj,gap,iter,time] =  smoothcovsel_solver(cov(z),covsel_param.rho,covsel_param.alpha,covsel_param.beta,...
            covsel_param.maxiter,covsel_param.freqprint,covsel_param.eps);
        feats = values{1};
        spCnt = size(feats{1},2);
     
        X = zeros(featSize ,spCnt);
        Y = zeros(labelCnt, spCnt);
     
        % make a vector of feat for each sp
        for j =1:spCnt
            spFeat=[];
            for l =1 : length(values{1})
                curFeat = feats{l};
                spFeat =  [spFeat;curFeat(:,j)];
                
            end
            X(:,j) = spFeat;
            [Y_new, votes, prediction_per_tree]  = classRF_predict(spFeat', model_smalltrees);
            Y(:,j) = votes;
        end
        
        [m n] =max(Y);
        classes = n';
        
        super_pixels = load( [ sp_dir, imageName]);
        
        % imageVarMat = findCovImages();
        %load('imageVarMat.mat');
        scores = Y' /scaleV;
        mmean = mean(Y);
        z=bsxfun(@minus,M,mmean);
        z = z /(std(z(:)));
        [w, theta, iter, avgTol, hasError] =GraphicalLasso(z,.05);
        
        % theta_edges = 1- (1./(.5 +exp(Theta)));
       
        theta(find(abs(theta) <0.001)) = 0;
        theta = theta./max(max(theta));
      
        theta_edges=-( 1-(1./exp(- abs(theta))));
        [nRows,nCols] = size(theta_edges);
        theta_edges(1:(nRows+1):nRows*nCols) = 0;
        
        %         [ color_mean , color_hist, center_loc] = findFeatForSmoothing(img, super_pixels.values{1} );
        %         conn = setEdgePotFine(fineSps, color_mean , color_hist, center_loc,theta_edges_pot);
        glasso_labels = SmoothGCO_Glasso(scores,super_pixels.values{1}, theta_edges, feats, pair_wise);
        
        centers = findCenterSps(super_pixels);
        color = feats{10};
        kernel =GaussKernel( super_pixels, color ,centers , theta_edges);
        edge_cost = tanh(theta);
        glasso_labels_kernel = SmoothGCO_GlassoGCMexKernel(scores,super_pixels,  edge_cost, feats, Theta_norm, kernel);
        
        smooth_labels = SmoothGCO(scores, super_pixels.values{1},[], feats);
    
        res.classes = classes;
        res.glasso_labels = glasso_labels;
        res.glasso_labels_kernel = glasso_labels_kernel;
        res.smooth_labels = smooth_labels;
        
        res.theta_edges= theta_edges;
        
        save([out_put_dir , imageName,'_out_5.mat'], 'res');
    end
    
end



