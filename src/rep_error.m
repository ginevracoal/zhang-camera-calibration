function [rep_error] = rep_error(points,estimations)
% compute the total reprojection error as the sum of the euclidean
% distances

diff=(points-estimations).^2;
errors=sqrt(diff(:,1)+diff(:,2));
%imageData(idx).rep_error=sum(errors,'all');
rep_error=sum(errors,'all')
end

