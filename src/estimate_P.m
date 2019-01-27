function [P] = estimate_P(imageData)
%% estimates the homography from a set of known 3d-2d correspondences

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
p=V(:,end); % the right  singular vector associated to the smallest 
            % singular value

% The computed vector contains the rows of the homography, so it has to be
% reshaped a square matrix and transposed.
P=reshape(p,[3 3])'; %%%%% 

if det(P)<0
    P = -P;
end

end