function [primary_locs, count_secondary_locs, secondary_locs, frames_secondary_locs] = search_and_insert(matchLoc1, matchLoc2, primary_locs, count_secondary_locs, secondary_locs, frames_secondary_locs, curr_frame_no)
%SEARCH_AND_INSERT Summary of this function goes here
%   Detailed explanation goes here

num_match_locs = size(matchLoc1 , 1);

num_pri_locs = nnz(primary_locs(:,1));

for m = 1: num_match_locs
    
    % Check if primary loc already present
    match_found = 0;
    for p = 1 : num_pri_locs
        
        if primary_locs(p, :) == matchLoc1(m, :)
            
            match_found = 1;
            num_sec_locs = count_secondary_locs(p);
            
            % Check if secondary loc already present
            sec_match_found = 0;
            for s = 1 : num_sec_locs
                
                %size (secondary_locs(p, s, :))
                %size (matchLoc2(m , :))
                
                if secondary_locs(p, s, 1) == matchLoc2(m , 1)
                    if secondary_locs(p, s, 2) == matchLoc2(m , 2)
                        sec_match_found = 1;
                    end
                end
            end
            
            % If secondary loc not found , insert new
            if sec_match_found == 0
                secondary_locs(p, num_sec_locs+1, :) = matchLoc2(m , :);
                count_secondary_locs(p) = count_secondary_locs(p)+ 1;
                frames_secondary_locs(p, num_sec_locs+1) = curr_frame_no;
            end
            
            
        end
            
    end
    
    % If primary loc not found - add new 
    if match_found == 0
        
        p = num_pri_locs + 1;
        primary_locs(p, :) = matchLoc1(m , :);
        
        num_sec_locs = count_secondary_locs(p);%nnz( secondary_locs(p,:,1));
        secondary_locs(p, num_sec_locs+1, :) = matchLoc2(m , :); 
        count_secondary_locs(p) = count_secondary_locs(p)+ 1;
        frames_secondary_locs(p, num_sec_locs+1) = curr_frame_no;
        
        num_pri_locs = num_pri_locs + 1;
    end    
end

