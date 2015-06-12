% Image Stitching for Defect Evaluation
% Author : Tanmay Patil
% University of Southern California - SHM
% Under Dr.Masri

% <Matlab script>: Containts the main routine to read images, find the stitched image and find differences

% ---------  READ MAIN CONFIG FILE ---------------%
fprintf('\n\nReading main config file..\n');

readKeys = {'main','database','folder','','none'} ;
key_value = inifile('/config_files/conf.ini','read',readKeys);
folder = key_value{1};

% Display
readKeys = {'variables','display','show_keypoints','','none'} ;
key_value = inifile('/config_files/conf.ini','read',readKeys);
show_keypoints = key_value{1};

readKeys = {'variables','display','show_mosaic','','none'} ;
key_value = inifile('/config_files/conf.ini','read',readKeys);
show_mosaic = key_value{1};

readKeys = {'variables','display','wait_for_each_image','','none'} ;
key_value = inifile('/config_files/conf.ini','read',readKeys);
wait_for_each_image = key_value{1};

readKeys = {'variables','display','binary_diff','','none'} ;
key_value = inifile('/config_files/conf.ini','read',readKeys);
binary_diff = key_value{1};

% Difference
readKeys = {'variables','difference','bw_threshold','','none'} ;
key_value = inifile('/config_files/conf.ini','read',readKeys);
bw_threshold = str2double(key_value{1});

readKeys = {'variables','difference','min_blob_pixels','','none'} ;
key_value = inifile('/config_files/conf.ini','read',readKeys);
min_blob_pixels = str2double(key_value{1});

readKeys = {'variables','difference','blob_shape','','none'} ;
key_value = inifile('/config_files/conf.ini','read',readKeys);
blob_shape = key_value{1};

% Algorithm
readKeys = {'variables','algorithms','blend_images','','none'} ;
key_value = inifile('/config_files/conf.ini','read',readKeys);
blend_images = key_value{1};


% ---------  READ DATABASE CONFIG FILE ---------------%
db_conf_path = strcat(folder, '\db_conf.ini');



if exist(db_conf_path, 'file')
    
    fprintf('Reading database config file..\n');
    
    readKeys = {'image_database','files','format','','none'} ;
    key_value = inifile(db_conf_path,'read',readKeys);
    format = key_value{1};

    readKeys = {'image_database','files','num','','none'} ;
    key_value = inifile(db_conf_path,'read',readKeys);
    num = key_value{1};
    num = str2num(num);

    readKeys = {'image_database','files','primary','','none'} ;
    key_value = inifile(db_conf_path,'read',readKeys);
    primary_file = key_value{1};
    
else
    
    fprintf('No database config file found, assignning defaults..\n');
    
    format = '.jpg';
    num = 'none';
    primary_file = 'none';
end

% ------------ GET PRIMARY IMAGE ------------------%

srcFiles = dir(folder);

if(strcmp(primary_file,'none') )
    % Takes primary file as first file
    img_primary_file = strcat(srcFiles(3).name );
    
else
    % Takes primary file from config
    img_primary_file = strcat(primary_file, format );
end

img_primary_file_path = strcat(folder, '/', img_primary_file);
fprintf('\nTaking primary file as : %s\n', img_primary_file);

img_primary_database = imread(img_primary_file_path);

if strcmp(blend_images,'yes'), img_primary_database = fn_pyrBlend( img_primary_database, img_primary_database); end

img_primary = img_primary_database;


% Mosaic is stated from primary image
imgmosaic = img_primary_database; 
[M1, N1, ~] = size(imgmosaic);
%zeros(M1,N1,channel,'uint8');

bw_final = ones(M1, N1);
bw_all_valid_regions = zeros(M1, N1);

match_no = 1;

% Find SIFT keypoints for current frame/primary image
[~, primary_des, primary_loc] = sift(img_primary);

% Set up matrices for storing
num_pri_keypoints = size(primary_des,1);
num_sec_images = size(srcFiles,1) - 3; % -3 for . , ..  and primary image

primary_locs = zeros(num_pri_keypoints, 2, 'double');
count_secondary_locs = zeros(num_pri_keypoints, 1, 'uint16');

secondary_locs = zeros(num_pri_keypoints, num_sec_images, 2, 'double');
frames_secondary_locs = zeros(num_pri_keypoints, num_sec_images, 'uint16');


Q = zeros(num_sec_images,4);
T = zeros(num_sec_images,3);

% ------------- LOOP FOR EACH IMAGE -------------%

for i=3:size(srcFiles)
    
    if(strcmp(srcFiles(i).name, img_primary_file) || strcmp(srcFiles(i).name, 'db_conf.ini'))
        continue;
    end
    
    if(srcFiles(i).isdir), continue; end
        
    
    fprintf('\n-----  MATCHING IMAGE %d : %s ------\n', match_no ,srcFiles(i).name);
    filename = strcat(folder, '/', srcFiles(i).name);
    img_secondary = imread(filename);
    
    [~, secondary_des, secondary_loc] = sift(img_secondary);
    
    [matchLoc1, matchLoc2, matchTable_loc, num] = siftMatch_pos(primary_des, primary_loc, secondary_des, secondary_loc);
    
    [H, corrPtIdx, is_valid] = findHomography(matchLoc2',matchLoc1');
    
    [ Q(match_no,:), ~, T(match_no,:) ] = get_camera_parameters(H);
    
    [primary_locs, count_secondary_locs, secondary_locs, frames_secondary_locs] = search_and_insert(matchLoc1, matchLoc2, primary_locs, count_secondary_locs, secondary_locs, frames_secondary_locs, match_no);

    write_files_for_ba(primary_locs, count_secondary_locs, secondary_locs, frames_secondary_locs, Q, T);
    

    match_no = match_no + 1;
end

%system('cd "C:\Users\Tanmay\Documents\MATLAB\Image_Stitching_for_Defect_Evaluation_v1.1\sba"');
system('C:\Users\Tanmay\Documents\MATLAB\Image_Stitching_for_Defect_Evaluation_v1.1\sba\eucsbademo.exe cams.txt pts.txt calib.txt');

return;

if match_no == 1
    fprintf('\nNo good matches found. \n');
    return;
end

fprintf('\nPerforming blob analysis..\n');

% Keep differences only in regions covered by new images
bw_final = bitand(bw_final, bw_all_valid_regions);

% Join the neighbouring blobs
if ~strcmp(blob_shape, 'none')
    se = strel('square',10);
    bw_final = imclose(bw_final,se);
end

% Eliminate small blobs
bw_final = bwareaopen(bw_final, min_blob_pixels);

% Display the result
highlight_blobs(img_primary_database, bw_final);
output_folder = strcat(folder, '/output');
mkdir(output_folder);

% ======  SAVE FILES  =========== %
fprintf('Saving Files..\n');

output_diff_path = strcat(output_folder, '/output_difference.fig');
savefig(output_diff_path);

output_mosaic_path = strcat(output_folder, '/stitched.jpg');
imwrite(imgmosaic, output_mosaic_path);

fprintf('Done.\n\n');
