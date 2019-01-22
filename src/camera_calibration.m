%% COMPLETE CAMERA CALIBRATION

%% create imageData 
clear imageData
wd = '/home/ginevracoal/MEGA/Università/DSSC/semester_3/ComputerVision-PatternRecognition/zhang-camera-calibration/src';
cd(wd)

iimage=[1 4 7 10];

for ii=1:length(iimage)
  imageFileName = fullfile(fullfile(wd,'../images'),['Image' num2str(iimage(ii)) '.tif']);
  
  imageData(ii).I = imread(imageFileName); %#ok %this removes the warning

  imageData(ii).XYpixel = detectCheckerboardPoints(imageData(ii).I); %#ok
end

%% establish the initial correspondences
squaresize=30; % [mm]
% this is because we know the geometry of the object

for ii=1:length(iimage) % for all the images
  figure
  imshow(imageData(ii).I) % display them
  
  XYpixel=imageData(ii).XYpixel;
  clear Xmm Ymm % to avoid overwriting
  for jj=1:length(XYpixel)
      [row,col]=ind2sub([12,13],jj); %linear index to row,col 
      
      % these values are fixed. In the iterative step we change XYpixel
      Xmm=(col-1)*squaresize;
      Ymm=(row-1)*squaresize;
      
      imageData(ii).XYmm(jj,:)=[Xmm Ymm];
     
      hndtxt=text(XYpixel(jj,1),...
          XYpixel(jj,2),...
          num2str([Xmm Ymm]));
      set(hndtxt,'fontsize',8,'color','cyan');
        
  end
end
  
%% estimate the homographies H

for ii=1:length(iimage)
    imageData(ii).H=estimate_homography(imageData(ii));
end

%% compute the intrinsic K
K = compute_intrinsic(imageData, iimage) 

%% compute the extrinsics R,t
for ii=1:length(iimage)
    [imageData(ii).R,...
     imageData(ii).t] = compute_extrinsics(imageData(ii), K);
end

%% radial distortion compensation
% compute the reprojection error on one image
% here I chose image 1
idx=1

[imageData(idx).est_proj,...
 imageData(idx).rep_error] = estimate_projections(imageData(idx), K);

% plot the reprojected points
figure
im = imageData(idx);
imshow(im.I);
hold on 
for jj=1:size(XYpixel)
    plot(im.XYpixel(jj,1),im.XYpixel(jj,2),'or') %o for circle and r for red
    plot(im.est_proj(jj,1),im.est_proj(jj,2),'og')
end

% estimate radial distortion parameters k1 and k2
k = estimate_dist_param(imageData(idx), K)

% FIRST ITERATION STEP
old_rep_error = imageData(idx).rep_error
% compensate for radial distortion
[imageData(idx).XYpixel,... %new estimated projections
 imageData(idx).rep_error] = radial_compensation(imageData, K, k);
% compute the error difference
error_difference = old_rep_error-new_rep_error
 
% ITERATIVE PART
threshold = 10;
while error_difference > threshold
    % take the last rep error value
    old_rep_error = imageData(idx).rep_error;

    % estimate P
    imageData(idx).H=estimate_homography(imageData(idx))
 
    % get intrinsic parameters from P
    K = compute_intrinsic(imageData, iimage)   
    
    % estimate k1 and k2
    k = estimate_dist_param(imageData(idx), K)

    % compensate for radial distortion
    [imageData(idx).est_proj,...
     imageData(idx).rep_error] = radial_compensation(imageData, K, k);
 
    % find the error difference
    error_difference = old_rep_error-new_rep_error
end

% show the result
figure
im = imageData(idx);
imshow(im.I)
hold on %to allow multiple superimposed drawings of the same figure
for ii=1:size(XYpixel,1)
    plot(im.XYpixel(ii,1),im.XYpixel(ii,2),'or') %o for circle and r for red
    plot(im.est_proj(ii,1),im.est_proj(ii,2),'og')
end