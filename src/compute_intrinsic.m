function [K] = compute_intrinsic(imageData, iimage)
%
%stack everything so as to get 
% a 2nx6 linear system Vb=0.

v = []; % 2x2x6
o = [];
V = []; % 2nx6 = 8x6

for kk=1:length(iimage)
    H = imageData(kk).H;
    
    for ii=1:2
      for jj=1:2
          v(ii,jj,:)=[ H(1,ii)*H(1,jj)
                       H(1,ii)*H(2,jj)+H(2,ii)*H(1,jj)
                       H(2,ii)*H(2,jj)
                       H(3,ii)*H(1,jj)+H(1,ii)*H(3,jj)
                       H(3,ii)*H(2,jj)+H(2,ii)*H(3,jj)
                       H(3,ii)*H(3,jj)];         
      end
    end
    
    v11 = reshape(v(1,1,:),6,1);
    v12 = reshape(v(1,2,:),6,1);
    v22 = reshape(v(2,2,:),6,1);
    
    V = [V; v12'; (v11-v22)']; 
    o = [o; 0; 0];
end

% check
%v(1,2,:)
%v12
%V

% Then I solve the linear system Vb=0 by least squares, 
% using the SVD decomposition.

[~,~,W]=svd(V); % search for a non trivial solution
b=W(:,end); % the right singular vector associated to the smallest 
            % singular value
B = [ b(1) b(2) b(4)
      b(2) b(3) b(5)
      b(4) b(5) b(6)];

% B should be positive definite, if not just take the opposite
if any(eig(B)<0)
    B = -B;
end

% Now I can calculate L from B, and then find the intrinsic parameters for
% the matrix K, which is intrinsic.
L = chol(B,'lower');
K = inv(L');
format short g
K = K./K(3,3); % imposing K33 = 1 for proper scale

end

