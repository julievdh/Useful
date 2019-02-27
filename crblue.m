function C = crblue(N)
% crblue is a 5-colour palette for colour-blindness. 

palette = [
221 0 49
125 160 175
169 193 203
255 109 182
87 87 95];

P = size(palette,1);

C = palette(1:N,:)/255;

% check 
% figure, hold on
% for i = 1:N
%    plot(rand,rand,'ko','markerfacecolor',C(i,:)) 
% end