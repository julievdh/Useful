function C = cblind(N)
% cblind is a 15-colour palette for colour-blindness. 
% 
%   CBLIND(N) returns an N-by-3 matrix containing a colormap. 
%   The colors are distinguishable for deuteranopia, protanopia and 
%   tritanopia. 
%   
%   http://www.somersault1824.com/tips-for-designing-scientific-figures-for-color-blind-readers/
%  

palette = [
0 0 0
0 73 73
0 146 146
255 109 182
255 182 119
73 0 146
0 109 219
182 109 255
109 182 255
182 219 255
146 0 0 
146 73 0
219 209 0
36 255 36
255 255 109];

P = size(palette,1);

C = palette(1:N,:)/255;