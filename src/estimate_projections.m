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

% compute the total reprojection error as the sum of the euclidean
% distances

diff=XYpixel-est_proj;
errors = sqrt(sum(diff.^2,2));
rep_error=sum(errors,'all');

end

