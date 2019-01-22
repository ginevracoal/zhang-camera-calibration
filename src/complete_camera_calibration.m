function [imageData, K] = complete_camera_calibration(imageData, iimage)


%% establish the initial correspondences
squaresize=30; % [mm]
% this is because we know the geometry of the object

for ii=1:length(iimage) % for all the images
  
  XYpixel=imageData(ii).XYpixel;
  clear Xmm Ymm % to avoid overwriting
  for jj=1:length(XYpixel)
      [row,col]=ind2sub([12,13],jj); %linear index to row,col 
      
      % these values are fixed. In the iterative step we change XYpixel
      Xmm=(col-1)*squaresize;
      Ymm=(row-1)*squaresize;
      
      imageData(ii).XYmm(jj,:)=[Xmm Ymm];
     
  end
end
  
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


