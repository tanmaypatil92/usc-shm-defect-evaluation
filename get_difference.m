function [ img_threshold ] = get_difference( img1, img2, bw_threshold )
%GET_DIFFERENCE Summary of this function goes here
%   Detailed explanation goes here


% -----------  DISPLAY DIFFERENCE ---------------%


img1_gray = rgb2gray(img1);
img2_gray = rgb2gray(img2);

myfilter = fspecial('gaussian',[10 10], 5);

blured_img1 = imfilter(img1_gray, myfilter, 'replicate');
blured_img2 = imfilter(img2_gray, myfilter, 'replicate');

%imshow(blured_mosaic);
%imshow(blured_primary);


img_diff = imabsdiff(blured_img1, blured_img2);
% figure('Name','Difference'), imshow(img_diff);


%outfilepath = strcat(images_path, '/imgout.jpg');
%imwrite(imgmosaic, outfilepath);

%------------  DIFFERENCE ANALYSIS  -----------------%
img_threshold = im2bw(img_diff, bw_threshold);

end

