function [ img_mosaic, img_patched ] = patch_mosaic( img_mosaic, img_patch, img_patch_valid, up , left )

% INPUTS :-
% img_mosaic : The image Mosaic to be patched
% img_patch : The image to patch onto
% img_patch_valid : Specifies which part of img_patch is valid
% up : topmost row to patch onto in img_mosaic
% left : leftmost collumn to patch onto in img_mosaic
%
% OUTPUT :-
% imgout : patched image



[M3,N3, ~] = size(img_patch);

[M1, N1, ~] = size(img_mosaic);

img_patched = zeros(M1, N1);

for i=1:(M3)
    for j=1:(N3)
        
        if( img_patch_valid(i,j) ~= 0)
            
            if( (up+i-1) > 0 && (left+j-1) > 0 )
                if ((up+i-1) < M1 && (left+j-1) < N1 )
                    img_mosaic(up+i -1 , left +j-1, :) = img_patch(i,j,:);
                    img_patched(up+i -1 , left +j-1) = 1;
                end
            end
        end
        
    end
end




