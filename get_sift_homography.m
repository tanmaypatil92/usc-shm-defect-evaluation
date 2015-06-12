function [ matchLoc1, matchLoc2, H, corrPtIdx, is_matched ] = get_sift_homography( matchLoc1,matchLoc2 )
%GET_SIFT_HOMOGRAPHY Summary of this function goes here
%   Detailed explanation goes here


[~, ~, channel] = size(img1);
if(channel > 1)
    img1_gray = rgb2gray(img1);
    img2_gray = rgb2gray(img2);
else
    img1_gray = img1;
    img2_gray = img2;
end


% use SIFT to find corresponding points
[matchLoc1, matchLoc2, num_total_matches] = siftMatch(img1_gray, img2_gray);
if (num_total_matches < 40), is_matched = 0;  return; end 

% use RANSAC to find homography matrix
[H,corrPtIdx, is_valid] = findHomography(matchLoc2',matchLoc1');
if(is_valid == 0), is_matched = 0;  return; end 



end

