function [imageData, K] = complete_camera_calibration(imageData, iimage)

%% establish the initial correspondences
[imageData] = establish_correspondences(imageData,iimage);
  
%% estimate the homographies H

for ii=1:length(iimage)
    imageData(ii).H=estimate_homography(imageData(ii));
end

%% compute the intrinsic K
K = compute_intrinsic(imageData, iimage);

%% compute the extrinsics R,t
for ii=1:length(iimage)
    [imageData(ii).R,...
     imageData(ii).t] = compute_extrinsics(imageData(ii), K);
end

end


