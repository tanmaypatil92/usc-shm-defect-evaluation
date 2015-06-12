function [ Q, R, T ] = get_camera_parameters( H )
%GET_CAMERA_PARAMETERS Summary of this function goes here
%   Detailed explanation goes here


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
T = col4';


% CONVERTING MATRIX TO QUARTERNIONS
m00 = R(1,1); m01 = R (1,2); m02 = R (1,3);
m10 = R(2,1); m11 = R (2,2); m12 = R (2,3);
m20 = R(3,1); m21 = R (3,2); m22 = R (3,3);

tr = m00 + m11 + m22;

if (tr > 0) 
  S = sqrt(tr+1.0) * 2; % S=4*qw 
  qw = 0.25 * S;
  qx = (m21 - m12) / S;
  qy = (m02 - m20) / S; 
  qz = (m10 - m01) / S; 
elseif ((m00 > m11) && (m00 > m22))
  S = sqrt(1.0 + m00 - m11 - m22) * 2; % S=4*qx 
  qw = (m21 - m12) / S;
  qx = 0.25 * S;
  qy = (m01 + m10) / S; 
  qz = (m02 + m20) / S; 
elseif (m11 > m22) 
  S = sqrt(1.0 + m11 - m00 - m22) * 2; % S=4*qy
  qw = (m02 - m20) / S;
  qx = (m01 + m10) / S; 
  qy = 0.25 * S;
  qz = (m12 + m21) / S; 
else
  S = sqrt(1.0 + m22 - m00 - m11) * 2; % S=4*qz
  qw = (m10 - m01) / S;
  qx = (m02 + m20) / S;
  qy = (m12 + m21) / S;
  qz = 0.25 * S;
end

Q = [qw qx qy qz];
    
end

