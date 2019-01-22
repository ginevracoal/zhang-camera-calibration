function [imageData] = iterative_radial_compensation(imageData, iimage, K, idx)


%% compute the current reprojection error
% here I chose image 1

[imageData(idx).est_proj,...
 imageData(idx).rep_error] = estimate_projections(imageData(idx), K);

% print the reprojection error
rep_error = imageData(idx).rep_error

% plot the reprojected points
figure
im = imageData(idx);
imshow(im.I);
hold on 
for jj=1:size(im.XYpixel)
    plot(im.XYpixel(jj,1),im.XYpixel(jj,2),'or') %o for circle and r for red
    plot(im.est_proj(jj,1),im.est_proj(jj,2),'og')
end


%% iterative radial distortion compensation

% estimate radial distortion parameters k1 and k2

k = estimate_dist_param(imageData(idx), K);

% FIRST ITERATION STEP
old_rep_error = imageData(idx).rep_error;
% compensate for radial distortion
[imageData(idx).XYpixel,... %new estimated projections
 imageData(idx).rep_error] = radial_compensation(imageData, K, k);
% compute the error difference
error_difference = old_rep_error-imageData(idx).rep_error;
 
% ITERATIVE PART
threshold = 10;
while error_difference > threshold
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

% print the reprojection error
rep_error = imageData(idx).rep_error

% show the result
figure
im = imageData(idx);
imshow(im.I)
hold on %to allow multiple superimposed drawings of the same figure
for ii=1:size(im.XYpixel,1)
    plot(im.XYpixel(ii,1),im.XYpixel(ii,2),'or') %o for circle and r for red
    plot(im.est_proj(ii,1),im.est_proj(ii,2),'og')
end

end