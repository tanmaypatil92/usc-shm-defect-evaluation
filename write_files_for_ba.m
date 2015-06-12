function [ ] = write_files_for_ba(primary_locs, count_secondary_locs, secondary_locs, frames_secondary_locs, Q, T)
%WRITE_FILES_FOR_BA Summary of this function goes here
%   Detailed explanation goes here

f_pts = fopen('pts.txt','w');

num_pts = nnz(primary_locs(:,1));

for p = 1:num_pts
    
    
    fprintf(f_pts,'%6f %6f 0.000000', primary_locs(p,1), primary_locs(p,2));
    
    num_frames = count_secondary_locs(p) + 1;
    fprintf(f_pts,' %d', num_frames);
    
    fprintf(f_pts,' 0 %6f %6f', primary_locs(p,1), primary_locs(p,2) );
    
    for s = 1:(num_frames-1)
    
        frame_no = frames_secondary_locs(p,s);
        fprintf(f_pts,' %d %6f %6f', frame_no, secondary_locs(p,s,1), secondary_locs(p,s,2) );
        
    end

    fprintf(f_pts,'\n');

end

fclose(f_pts);

% -----------  Writing Cams file  -------------------%
f_cams = fopen('cams.txt','w');

num_cams = nnz(Q(:,1));

fprintf(f_pts,'1.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000\n');

for c = 1:num_cams

    fprintf(f_pts,'%6f %6f %6f %6f %6f %6f %6f\n', Q(c,1),  Q(c,2),  Q(c,3),  Q(c,4), T(c, 1), T(c, 2), T(c, 3));
    
end

fclose(f_cams);
