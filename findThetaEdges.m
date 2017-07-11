
function [theta, theta_edges , theta_edges_pot] = findThetaEdges(M, a, b)
%  
mmean = mean(M);
z=bsxfun(@minus,M,mmean);
z = z /(std(z(:)));
[theta,obj,gap,iter,time] = smoothcovsel_solver(cov(z),0.05,0.2,1000,300,1,0.01);
%         [w, theta, iter, avgTol, hasError] =GraphicalLasso(z,.05);

% theta_edges = 1- (a/(b +exp(Theta)));

theta(find(abs(theta) <0.003)) = 0;
[nRows,nCols] = size(theta);
theta(1:(nRows+1):nRows*nCols) = 0;


theta_conn = theta;
theta_conn(theta_conn~=0) = 1;
theta_edges = theta * 0;
theta_edges_pot = theta * 0;
[nRows,nCols] = size(theta_edges);
for r = 1:nRows
    for c = 1:nCols
        if (theta(c,r) ~= 0)
            theta_edges(c,r)= (a/(1+exp(-b*theta(c,r))));
            theta_edges_pot(c,r)= (a/(1+exp(b*theta(c,r))));
        end
    end
end

%        theta_edges = (1./(1+exp( (theta))));
theta_edges(1:(nRows+1):nRows*nCols) = 0;


