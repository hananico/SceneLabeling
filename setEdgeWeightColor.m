function c = setEdgeWeightColor(super_pixels, color_mean, spCnt, theta,weight)

c=GetConnectivity(super_pixels);

sp_centers =findCenterSps(super_pixels);

 
for i=1:spCnt
    for j=1:spCnt
        if c(i,j)~=0
            %             [colDist , histDist, posDist] = findEdgesDist(color_mean(i,:),...
            %                 color_mean(j,:),coler_hist(i,:) , coler_hist(j,:) ,...
            %                 sp_centers(:,i),sp_centers(:,j) );
            %             histDist = exp(-pdist2( coler_hist(i,:), coler_hist(j,:), 'chisq'));

            c(i,j)=weight/(1+norm( color_mean(i,:)-color_mean(j,:)));
            %              c(i,j)=weight/(1+ histDist);
            %             c(i,j) = w1* colDist + w2*histDist + w3* posDist;
        else
            %                if(theta(i,j)~=0)
            %                     c(i,j) = theta(i,j) ;
            %                 end
        end
        %
    end
end


function [colDist , histDist , posDist] = findEdgesDist(sp1Cl, sp2Cl, sp1Hist, ...
    sp2Hist, sp1Pos, sp2Pos)
thr = 30/255;
colDist = exp(-min (norm(sp1Cl-sp2Cl), thr));
histDist = exp(-pdist2( sp1Hist, sp2Hist, 'chisq'));
diagImg = sqrt(256^2 + 256^2);
posDist = exp(-(norm(sp1Pos-sp2Pos)/diagImg));

