function [imageData] = create_imagedata(iimage)

%% create imageData 
clear imageData

for ii=1:length(iimage)
  imageFileName = fullfile(fullfile('images/'),['Image' num2str(iimage(ii)) '.tif']);
  
  imageData(ii).I = imread(imageFileName); %#ok %this removes the warning

  imageData(ii).XYpixel = detectCheckerboardPoints(imageData(ii).I); %#ok
end

end