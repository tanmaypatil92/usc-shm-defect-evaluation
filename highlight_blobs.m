function [ ] = highlight_blobs( img, bw_blobs)
%HIGHLIGHT_BLOBS Summary of this function goes here
%   Detailed explanation goes here

B = bwboundaries(bw_blobs);

figure('Name','Blob'), imshow(img);
hold on
text(10,10,strcat('\color{green}Difference Found:',num2str(length(B))))

for k = 1:length(B)
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
end

hold off

end

