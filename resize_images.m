dir_path = 'C:\Users\Tanmay\Documents\MATLAB\image mosaic\images\flashlights';

files = dir(dir_path);

for i =1:size(files)
    
    if(i == 1 || i == 2 )
        continue;
    end
    
    file_path = strcat(dir_path,'\', files(i).name);
    A = imread(file_path);

    B = imresize(A, [360 640]);

    imwrite(B, file_path, 'jpg');
    %figure, imshow(B);

end