function  k =GaussKernel(super_pixels, color,sp_centers  , theta_edges, params)

%
% coler_hist = features{12}';
% sp_centers =findCenterSps(super_pixels);
spCnt = length(unique(super_pixels));
%alpha = params.alpha ;
%beta = 60 ;
%gamma =3;

color_mean = 255* (color);
k= zeros(spCnt, spCnt);

for i=1:spCnt
    for j=1:spCnt
        %         if (i~=j)
        if theta_edges(i,j)~=0
            k(i,j)= params.w1 * exp( (- norm(color_mean(:,i)-color_mean(:,j)) / ( 2* params.alpha^2) )...
                -  (norm(sp_centers(:,i) - sp_centers(:,j)) / (2*params.beta^2)) ) + ...
                params.w2 * exp( -norm(sp_centers(:,i) - sp_centers(:,j)) / (2*params.gamma ^2));
        end
        %
    end
end
