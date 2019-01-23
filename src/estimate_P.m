function [P] = estimate_P(imageData)
est_proj=imageData.est_proj;
XYpixel=imageData.XYpixel;
XYmm=imageData.XYmm;
A=[];
b=[];
for jj=1:length(est_proj)

    Xpixel=est_proj(jj,1);
    Ypixel=est_proj(jj,2);
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
p=V(:,end); % the right  singular vector associated to the smallest 
            % singular value

% reshape the vector in a square matrix and transpose it
P=reshape(p,[3 3])'; 
end