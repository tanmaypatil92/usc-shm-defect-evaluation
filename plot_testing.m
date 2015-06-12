% Ignore file not currently used

% p1 = [0 0 0];
% p2 = [0 0 -1];
% 
% figure
% hold on
% X = [p1(1) p2(1)];
% Y = [p1(2) p2(2)];
% Z = [p1(3) p2(3)];
% 
% plot3(X, Y, Z)
% 
% 
% T = [50 10 0];
% 
% p1 = p1 + T;
% p2 = p2 + T;
% 
% X = [p1(1) p2(1)];
% Y = [p1(2) p2(2)];
% Z = [p1(3) p2(3)];
% 
% plot3(X, Y, Z)
% 
% 
% hold off

% a = [2 3 5];
% b = [1 1 0];
% c = a+b;
% 
% starts = zeros(3,3);
% ends = [a;b;c];
% 
% quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3))
% axis equal

cam_s = [0 0 0];
cam_e = [0 1 0];

T = [10 0 0];
cam1_s = cam_s + T;
cam1_e = cam_e + T;

T = [0 20 0];
cam2_s = cam_s + T;
cam2_e = cam_e + T;

starts = [cam_s; cam1_s; cam2_s];
ends =   [cam_e; cam1_e; cam2_e];

quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3))
%axis equal

