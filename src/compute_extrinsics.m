function [R,t] = compute_extrinsics(imageData, K)

H = imageData.H;

r1 = K\H(:,1); % hi is the i'th column of H
r2 = K\H(:,2); 

% this is not be needed
%lambda = 1./norm(r1); %~= 1./norm(r2)

%r1 = lambda*r1;
%r2 = lambda*r2;
r3 = cross(r1,r2);

t = K\H(:,3);
%t = lambda*t;

%imageData.t = t;
%imageData.R = [r1'; r2'; r3'];
%imageData.lambda = lambda;

R = [r1 r2 r3];
t = t;

%% checking the computed matrices against H
%K*[R(:,1:2) t]
%H

end

