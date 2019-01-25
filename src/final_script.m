clear all

% to disable images
%set(0,'DefaultFigureVisible','on')

%creating imagedata objects
iimage=[1 4 7 10];
imageData = create_imagedata(iimage);

% perform Zhang camera calibration
[imageData, K] = complete_camera_calibration(imageData, iimage);

% compute the estimated projections for one of the images
idx=1;
[imageData(idx).est_proj,...
 imageData(idx).rep_error] = estimate_projections(imageData(idx), K);
imageData(idx).rep_error

% plot the reprojected points
figure
im = imageData(idx);
imshow(im.I);
hold on 
for jj=1:size(im.XYpixel)
    plot(im.XYpixel(jj,1),im.XYpixel(jj,2),'or') %o for circle and r for red
    plot(im.est_proj(jj,1),im.est_proj(jj,2),'og')
end

% estimate radial distortion parameters k1 and k2
k = estimate_dist_param(imageData(idx), K);

% perform  radial distortion compensation on the chosen image
%idx = 1;
[imageData] = iterative_radial_compensation(imageData, iimage, K, k, idx);

% show the result of radial compensation
figure
im = imageData(idx);
imshow(im.I)
hold on 
for ii=1:size(im.XYpixel,1)
    plot(im.XYpixel(ii,1),im.XYpixel(ii,2),'or') %o for circle and r for red
    plot(im.est_proj(ii,1),im.est_proj(ii,2),'og')
end


% superimpose a 3d object to each image
for ii=1:length(iimage)
    clear im
    figure
    im=imageData(ii).I;
    imshow(im)
    P = K*[imageData(ii).R imageData(ii).t]; % 3x4
   
    hold on % superimpose something
    
    vtheta=0:0.01:2*pi; % take equally spaced points
    centerX=150; % these are mm of course
    centerY=150;
    radius=100;
    % discretize the circle by taking some coordinates on it
    vX=centerX+radius*cos(vtheta);
    vY=centerY+radius*sin(vtheta);
    
    % projections from plane z=0
    vZ=zeros(1,length(vtheta));
    homogeneous = [vX; vY; vZ; ones(1,length(vtheta))];
    proj_hom=P*homogeneous;
    proj=[ proj_hom(1,:)./proj_hom(3,:); ...
           proj_hom(2,:)./proj_hom(3,:)];
    
    f=fill(proj(1,:),proj(2,:),'g');
    set(f,'facealpha',.5)
    
    % projections from plane z!=0
    hold on
   
    vZ=repmat(5e6,1,length(vtheta));
    new_homogeneous = [vX; vY; vZ; ones(1,length(vtheta))];
    new_proj_hom = P*new_homogeneous;
    new_proj = [new_proj_hom(1,:)./new_proj_hom(3,:);...
                new_proj_hom(2,:)./new_proj_hom(3,:)];
                
    f2=fill(new_proj(1,:),new_proj(2,:),'r');
    set(f2,'facealpha',.5)
end