function [k] = estimate_dist_param(imageData, K)
%

% get intrinsic parameters
u0=K(1,3);
v0=K(2,3);
alpha_u=K(1,1);
alpha_v=K(2,2)*alpha_u./sqrt(K(1,2)^2+alpha_u^2);

XYpixel = imageData.XYpixel;
est_proj = imageData.est_proj;

% calculate radial distortion parameters
A=[];
b=[];

% here we solve an overdetermined system
for ii=1:length(XYpixel)
    
    % ideal pixels
    u=XYpixel(ii,1);
    v=XYpixel(ii,2);
    
    % estimated pixels
    u_hat=est_proj(ii,1);
    v_hat=est_proj(ii,2);
    
    % radial distortion coefficient
    rd2=((u-u0)./alpha_u)^2+((v-v0)./alpha_v)^2;
    
    A=[A;...
       (u-u0)*rd2 (u-u0)*(rd2^2);...
       (v-v0)*rd2 (v-v0)*(rd2^2)];
    b=[b; u_hat-u; v_hat-v];
end

%k=vpa(A)\vpa(b)
k=pinv(A)*b;

%% check the error
% sum(abs(A*k-b))
end

