function [H, corrPtIdx, is_valid] = findHomography(pts1,pts2)
% [H corrPtIdx] = findHomography(pts1,pts2)
%	Find the homography between two planes using a set of corresponding
%	points. PTS1 = [x1,x2,...;y1,y2,...]. RANSAC method is used.
%	corrPtIdx is the indices of inliers.

%read_config = {'variables','findHomography', '', 'none' };
%config_value = inifile('config_files/conf.ini','read',read_config);

coef.minPtNum = 4; % Orirnally 4
coef.iterNum = 400; % Orirnally 30
coef.thDist = 4; %Orignally 4
coef.thInlrRatio = .5; % Orignally 0.1 , (0.1 * n) => threshold


[H, corrPtIdx, is_valid] = ransac1(pts1,pts2,coef,@solveHomo,@calcDist);

fprintf('Inliers found : %d\n',size(corrPtIdx,2));

end

function d = calcDist(H,pts1,pts2)
%	Project PTS1 to PTS3 using H, then calcultate the distances between
%	PTS2 and PTS3

if (size(pts1,1) ~= 2 || size(pts2,1) ~= 2)
    error = 1;
end

if (size(pts1,2) ~= size(pts2,2))
    error = 1;
end

if (size(H,1) ~= 3 || size(H,2) ~= 3 )
    error = 1;
end

n = size(pts1,2);
pts3 = H*[pts1;ones(1,n)];
pts3 = pts3(1:2,:)./repmat(pts3(3,:),2,1);
d = sum((pts2-pts3).^2,1);

end