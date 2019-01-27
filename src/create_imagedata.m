function [imageData] = create_imagedata(iimage)

%% create imageData 
clear imageData

for ii=1:length(iimage)
  imageFileName = fullfile(fullfile('images/'),['Image' num2str(iimage(ii)) '.tif']);
  
  imageData(ii).I = imread(imageFileName); %#ok %this removes the warning

  % this is the real value of pixel coordinates
  imageData(ii).XYpixel = detectCheckerboardPoints(imageData(ii).I); %#ok
  
  % this will be the value of the estimated projections
  imageData(ii).est_proj = imageData(ii).XYpixel;
end

end