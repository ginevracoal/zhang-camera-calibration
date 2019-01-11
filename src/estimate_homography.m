function [homography] = estimate_homography(imageData)
% This function estimates the homography for some given correspondences on
% a single image.

    XYpixel=imageData.XYpixel;
    XYmm=imageData.XYmm;
    A=[];
    b=[];
    for jj=1:length(XYpixel)
           
        Xpixel=XYpixel(jj,1);
        Ypixel=XYpixel(jj,2);
        Xmm=XYmm(jj,1);
        Ymm=XYmm(jj,2);
        
        m=[Xmm; Ymm; 1]; % the semicolumn tells not to display the object
        O=[0;0;0];
        % here ' indicates the transpose matrix
        % I'm adding two rows to A at each iteration 
        % (A finally has 2x156=312 rows)
        A=[A; m' O' -Xpixel*m';O' m' -Ypixel*m']; %#ok
        b=[b;0;0]; %#ok
        % each time i'm adding a new row entry to A and b,
        % finally getting a 2nx12 system
                
    end
    [U,S,V]=svd(A); % search for a non trivial solution
    h=V(:,end); % the right  singular vector associated to the smallest 
                % singular value
    
    % reshape the vector in a square matrix and transpose it
    H=reshape(h,[3 3])'; %reshape acts column-wise so we neet to transpose

homography = H;
end

