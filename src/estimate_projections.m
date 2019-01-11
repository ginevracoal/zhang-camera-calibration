function [est_proj, rep_error] = estimate_projections(imageData, K)
% given an image and the extrinsic K, it projects mm coordinates into the
% pixel ones and computes the reprojection error against the ideal pixel
% coordinates

% for cleaner code
%lambda = imageData.lambda;
R = imageData.R;
t = imageData.t;
XYpixel=imageData.XYpixel;
XYmm=imageData.XYmm;

est_proj=[];

for jj=1:length(XYpixel)
    Xmm=XYmm(jj,1);
    Ymm=XYmm(jj,2);
    m=[Xmm; Ymm; 1];
    
    % now we compute the projections
    P = K*[R(:,1:2) t];
    est = P*m;
    norm_est = [est(1)./est(3) est(2)./est(3)];
    est_proj = [est_proj; norm_est];
    
    %% check: this should be approximately XYpixel(jj,:)
    %norm_est
    %XYpixel(jj,:)
end

%imageData(idx).est_proj = est_proj;

% compute the total reprojection error as the sum of the euclidean
% distances

%rep_error(XYpixel, est_proj)

diff=(XYpixel-est_proj).^2;
errors=sqrt(diff(:,1)+diff(:,2));
%imageData(idx).rep_error=sum(errors,'all');
rep_error=sum(errors,'all')

end

