function [undist_est_proj, rep_error] = radial_compensation(imageData, K, k)
% given an image, the extrinsic K and the radial parameters k1 and k2
% it performs radial compensation and computes the new undistorted 
% projected points

%XYpixel=imageData.XYpixel;
est_proj = imageData.est_proj;

% get intrinsic parameters
%u0=K(1,3);
%v0=K(2,3);
%alpha_u=K(1,1);
%alpha_v=K(2,2)*alpha_u./sqrt(alpha_u^2+K(1,2)^2);

undist_est_proj=[];
for jj=1:length(est_proj)
    % normalize the distorted pixel coordinates (substract the center of 
    % projection and divide by the focal length) by using K^{-1}
    
    %x_hat=(est_proj(jj,1)-u0)./alpha_u
    %y_hat=(est_proj(jj,2)-v0)./alpha_v
    
    xy_hat = inv(K)*[est_proj(jj,1); est_proj(jj,2); 1];
    x_hat = xy_hat(1);
    y_hat = xy_hat(2);
    
    % solve using Newton method 
    fun = @(x)radial_comp(x, x_hat, y_hat, k);
    x0 = [double(x_hat),double(y_hat)];
    options = optimset('Display','off');
    sol = fsolve(fun,x0,options);
    
    % find the undistorted pixel coordinates (x,y)
    
    %x = u0+sol(1)*alpha_u;
    %y = v0+sol(2)*alpha_v;
    
    xy = K*[sol(1); sol(2); 1];
    x = xy(1);
    y = xy(2);
    undist_est_proj = [undist_est_proj; x y];
end

% check: the result should be approximately XYpixel(jj,:)
%undist_est_proj(2:8,:)-XYpixel(2:8,:)
    
% compute the total reprojection error as the sum of the euclidean
% distances
%diff=XYpixel-undist_est_proj;
diff=est_proj-undist_est_proj;
errors = sqrt(sum(diff.^2,2));
rep_error = sum(errors,'all')

function F=radial_comp(x, x_hat, y_hat, k)
    F(1) = double(x_hat - x(1)*(1+k(1)*(x(1)^2+x(2)^2)+k(2)*(x(1)^4+2*x(1)^2*x(2)^2+x(2)^4)));
    F(2) = double(y_hat - x(2)*(1+k(1)*(x(1)^2+x(2)^2)+k(2)*(x(1)^4+2*x(1)^2*x(2)^2+x(2)^4)));
end

end


