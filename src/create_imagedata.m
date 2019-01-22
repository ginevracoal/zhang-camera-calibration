function [imageData, iimage] = create_imagedata(wd)

%% create imageData 
clear imageData

iimage=[1 4 7 10];

for ii=1:length(iimage)
  imageFileName = fullfile(fullfile(wd,'../images'),['Image' num2str(iimage(ii)) '.tif']);
  
  imageData(ii).I = imread(imageFileName); %#ok %this removes the warning

  imageData(ii).XYpixel = detectCheckerboardPoints(imageData(ii).I); %#ok
end

end