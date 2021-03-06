function [H] = estimate_homography(imageData)
%% estimates the homography from a set of known 3d-2d correspondences

% XYpixel=imageData.XYpixel;
% XYmm=imageData.XYmm;
% A=[];
% b=[];
% for jj=1:length(XYpixel)
% 
%     Xpixel=XYpixel(jj,1);
%     Ypixel=XYpixel(jj,2);
%     Xmm=XYmm(jj,1);
%     Ymm=XYmm(jj,2);
% 
%     m=[Xmm; Ymm; 1]; % the semicolumn tells not to display the object
%     O=[0;0;0];
%     % here ' indicates the transpose matrix
%     % I'm adding two rows to A at each iteration 
%     % (A finally has 2x156=312 rows)
%     A=[A; m' O' -Xpixel*m';O' m' -Ypixel*m']; %#ok
%     b=[b;0;0]; %#ok
%     % each time i'm adding a new row entry to A and b,
%     % finally getting a 2nx12 system
% 
% end
% [~,~,V]=svd(A); % search for a non trivial solution
% h=V(:,end); % the right  singular vector associated to the smallest 
%             % singular value
% 
% % reshape the vector in a square matrix and transpose it
% H=reshape(h,[3 3])'; %reshape acts column-wise so we need to transpose


est_proj=imageData.est_proj;
%XYpixel=imageData.XYpixel;
XYmm=imageData.XYmm;

%% Solve Ap=0 system
% I should get a 2n x 9 system from n correspondences
A=[];
o=[];
for jj=1:length(est_proj) % n=156 correspondences

    Xpixel=est_proj(jj,1);
    Ypixel=est_proj(jj,2);
    Xmm=XYmm(jj,1);
    Ymm=XYmm(jj,2);

    m=[Xmm; Ymm; 1]; 
    O=[0;0;0];
    
    % I'm adding two rows to A and b for each correspondence
    A=[A; m' O' -Xpixel*m';O' m' -Ypixel*m']; %#ok
    o=[o;0;0]; %#ok

end

% check: A should be a 312x9 matrix
% size(A)

% Least squares method
[~,~,V]=svd(A); % search for a non trivial solution
h=V(:,end); % the right  singular vector associated to the smallest 
            % singular value

% The computed vector contains the rows of the homography, so it has to be
% reshaped a square matrix and transposed.
H=reshape(h,[3 3])'; %%%%% 

if det(H)<0
    H = -H;
end

end

