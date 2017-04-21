function [x, y] = polar2xy(r,theta)
% (x,y) are the Cartesian coordinates of polar coordinates (r,theta). 
% r is the radial coordinate and theta is the angle, also called phase.
% theta is in degrees.

rads= theta*pi/180;  % translate degrees to radians
x= r*cos(rads);
y= r*sin(rads);
