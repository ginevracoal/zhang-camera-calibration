function [imageData] = establish_correspondences(imageData,iimage)
% establishes correspondences between pixels and mm
squaresize=30; % [mm]

for ii=1:length(iimage) % for all the images
  %figure
  %imshow(imageData(ii).I) % display them
  
  XYpixel=imageData(ii).XYpixel;

  for jj=1:length(XYpixel)
      [row,col]=ind2sub([12,13],jj); %linear index to row,col 
      
      Xmm=(col-1)*squaresize;
      Ymm=(row-1)*squaresize;
      
      imageData(ii).XYmm(jj,:)=[Xmm Ymm];
        
  end
 
end

end

