function [ imgout, imgout_valid, up, left, is_matched ] = imMosaic_sba( img1,img2,adjColor,show_keypoints )
%[ imgout ] = imMosaic( img1,img2,adjColor )
%	img1 and img2 can (both) be rgb or gray, double or uint8.
%	If you have more than 2 images to do mosaic, call this function several
%	times.
%	If you set adjColor to 1, imMosaic will try to try to adjust the
%	color(for rgb) or grayscale(for gray image) of img1 linearly, so the 2 
%	images can join more naturally.
%	Yan Ke @ THUEE, 20110123, xjed09@gmail.com

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
if (num_total_matches < 40), is_matched = 0; imgout =0; imgout_valid=0; up=0; left=0; return; end 

% use RANSAC to find homography matrix
[H,corrPtIdx, is_valid] = findHomography(matchLoc2',matchLoc1');
if(is_valid == 0), is_matched = 0; imgout =0; imgout_valid=0; up=0; left=0; return; end 

num_inlier_matches = size(corrPtIdx);
if (num_inlier_matches < 30), is_matched = 0; imgout =0; imgout_valid=0; up=0; left=0; return; end 

% Addition for the sba
% Computing the Camera Pose matrix

n1 = norm(H(:,1));
n2 = norm(H(:,2));
tnorm = ( n1 + n2 ) / 2.0;

col1 = H(:,1) / n1;
col2 = H(:,2) / n2;

col3 = cross(col1, col2);

col4 = H(:,3) / tnorm;

%pose = [c1 c2 c3 c4];
R = [col1 col2 col3];
T = col4;

tform = maketform('projective',H');

% TANMAY - REMOVED 
%img1 = imread(img1_file);
%img2 = imread(img2_file);

% *CHANGE - Adding for rgb input images
%img1 = rgb2gray(img1);
%img2 = rgb2gray(img2);


img2_projected = imtransform(img2,tform); % reproject img2

[M2 , N2] = size(img2_gray);
img2_projected_valid = ones(M2,N2);
img2_projected_valid(:,1) = 0;
img2_projected_valid(:,N2) = 0;
img2_projected_valid(1,:) = 0;
img2_projected_valid(M2,:) = 0;

img2_projected_valid = imtransform(img2_projected_valid,tform);

%figure,imshow(img21_valid)


%figure,imshow(img1)
%figure,imshow(img21)

% OUTLIER EXCLUDED
% Show a figure with lines joining the accepted matches.
% Create a new image showing the two images side by side.

if(strcmp(show_keypoints,'yes'))
    img3 = appendimages(img1,img2);
    figure('Position', [100 100 size(img3,2) size(img3,1)]);
    %colormap('gray');
    imagesc(img3);
    hold on;
    cols1 = size(img1,2);
    %fprinf('Inlier point indexs : %d', size(corrPtIdx,2));
    for i = 1: size(corrPtIdx,2)

        line([matchLoc1(corrPtIdx(i),1) matchLoc2(corrPtIdx(i),1)+cols1], ...
             [matchLoc1(corrPtIdx(i),2) matchLoc2(corrPtIdx(i),2)], 'Color', 'c');

    end
    hold off;
end

% adjust color or grayscale linearly, using corresponding infomation
%[M1 N1 dim] = size(img1);
%[M2 N2 ~] = size(img2);
% if exist('adjColor','var') && adjColor == 1
% 	radius = 2;
% 	x1ctrl = matchLoc1(corrPtIdx,1);
% 	y1ctrl = matchLoc1(corrPtIdx,2);
% 	x2ctrl = matchLoc2(corrPtIdx,1);
% 	y2ctrl = matchLoc2(corrPtIdx,2);
% 	ctrlLen = length(corrPtIdx);
% 	s1 = zeros(1,ctrlLen);
% 	s2 = zeros(1,ctrlLen);
% 	for color = 1:dim
% 		for p = 1:ctrlLen
% 			left = round(max(1,x1ctrl(p)-radius));
% 			right = round(min(N1,left+radius+1));
% 			up = round(max(1,y1ctrl(p)-radius));
% 			down = round(min(M1,up+radius+1));
% 			s1(p) = sum(sum(img1(up:down,left:right,color))); % 取四周点色度
% 		end
% 		for p = 1:ctrlLen
% 			left = round(max(1,x2ctrl(p)-radius));
% 			right = round(min(N2,left+radius+1));
% 			up = round(max(1,y2ctrl(p)-radius));
% 			down = round(min(M2,up+radius+1));
% 			s2(p) = sum(sum(img2(up:down,left:right,color)));
% 		end
% 		sc = (radius*2+1)^2*ctrlLen;
% 		adjcoef = polyfit(s1/sc,s2/sc,1);
% 		img1(:,:,color) = img1(:,:,color)*adjcoef(1)+adjcoef(2);
% 	end
% end
% 

% do the mosaic
pt = zeros(3,4);
pt(:,1) = H*[1;1;1];
pt(:,2) = H*[N2;1;1];
pt(:,3) = H*[N2;M2;1];
pt(:,4) = H*[1;M2;1];
x2 = pt(1,:)./pt(3,:);
y2 = pt(2,:)./pt(3,:);

up = round(min(y2));
Yoffset = 0;

% REMOVING
%if up <= 0
%	Yoffset = -up+1;
%	up = 1;
%end

left = round(min(x2));
Xoffset = 0;

% REMOVING
% if left<=0
% 	Xoffset = -left+1;
% 	left = 1;
% end



imgout = img2_projected;
imgout_valid = img2_projected_valid;
is_matched = 1;

% img1 is above img21
%imgout(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = img1;
%imgout(up:up+M3-1,left:left+N3-1,:) = img21;

%imshow(imgout);

end

