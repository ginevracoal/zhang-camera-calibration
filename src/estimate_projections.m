function [new_est_proj, rep_error] = estimate_projections(imageData, K)
% Given an image and an intrinsic K, it projects mm coordinates into the
% pixel ones and computes the reprojection error against the ideal pixel
% coordinates.

%lambda = imageData.lambda;
R = imageData.R;
t = imageData.t;
%XYpixel=imageData.XYpixel;
est_proj = imageData.est_proj;
XYmm=imageData.XYmm;

new_est_proj=[];

for jj=1:length(XYmm)
    Xmm=XYmm(jj,1);
    Ymm=XYmm(jj,2);
    m=[Xmm; Ymm; 1];
    
    % now we compute the projections
    P = K*[R(:,1:2) t];
    est = P*m;
    norm_est = [est(1)./est(3) est(2)./est(3)];
    new_est_proj = [new_est_proj; norm_est];
    
    %% check: this should be approximately XYpixel(jj,:)
    %norm_est
    %XYpixel(jj,:)
end

% compute the total reprojection error as the sum of the euclidean
% distances

%diff=XYpixel-est_proj;
diff=est_proj-new_est_proj;
errors = sqrt(sum(diff.^2,2));
rep_error=sum(errors,'all');

end

