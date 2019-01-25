function [R,t] = compute_extrinsics(imageData, K)

H = imageData.H;

r1 = K\H(:,1); % hi is the i'th column of H
r2 = K\H(:,2); 
t = K\H(:,3);

% normalization
lambda = 1/norm(r1); %~= 1/norm(r2)
%r1 = r1*lambda;
%r2 = r2*lambda;
%t = t*lambda;

% check: r1 and r2 should be othornorormal!
format short g
dot(r1,r2) % == 0
dot(r1,r1)

% final rotation matrix
r3 = cross(r1,r2);
R = [r1 r2 r3]; %%% something's wrong...


%% checking the computed matrices against H
%sum(abs(K*[R(:,1:2) t]-H),'all')

% find the orthogonal matrix closest to R in the Frobenius norm
%[U,~,V]=svd(R); 
%R = U*V'

end

