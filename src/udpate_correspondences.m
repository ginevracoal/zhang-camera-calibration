%%% NOT USED, incomplete.
function [new] = establish_correspondences(image, ,iimage)
% establishes correspondences between pixels and mm

for ii=1:length(iimage) % for all the images
  figure
  imshow(imageData(ii).I) % display them
  
  XYpixel=imageData(ii).XYpixel;
  %clear Xmm Ymm % to avoid overwriting
  for jj=1:length(XYpixel)
      [row,col]=ind2sub([12,13],jj); %linear index to row,col 
      
      Xmm=(col-1)*squaresize;
      Ymm=(row-1)*squaresize;
      
      imageData(ii).XYmm(jj,:)=[Xmm Ymm];
     
      hndtxt=text(XYpixel(jj,1),...
          XYpixel(jj,2),...
          num2str([Xmm Ymm]));
      set(hndtxt,'fontsize',8,'color','cyan');
        
  end
 
end

end

