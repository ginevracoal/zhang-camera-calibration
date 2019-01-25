function [imageData] = iterative_radial_compensation(imageData, iimage, K, k, idx)
% apply the iterative method by imposing a threshold on the
% reprojection error difference

% FIRST ITERATION STEP
old_rep_error = imageData(idx).rep_error;
% compensate for radial distortion
[imageData(idx).est_proj,... %new estimated projections
 imageData(idx).rep_error] = radial_compensation(imageData, K, k);
% compute the error difference
error_difference = old_rep_error-imageData(idx).rep_error;
 
% ITERATIVE PART
threshold = 0.01;
while abs(error_difference) > threshold
    % take the last rep error value
    old_rep_error = imageData(idx).rep_error;

    % estimate P
    imageData(idx).H = estimate_P(imageData(idx));
 
    % get intrinsic parameters from P
    K = compute_intrinsic(imageData, iimage);
    
    % estimate k1 and k2
    k = estimate_dist_param(imageData(idx), K);

    % compensate for radial distortion
    [imageData(idx).est_proj,...
     imageData(idx).rep_error] = radial_compensation(imageData, K, k);
 
    % find the error difference
    error_difference = old_rep_error-imageData(idx).rep_error;
end

% print the final error
final_error_difference = error_difference

end