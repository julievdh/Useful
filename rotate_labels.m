function rotate_labels(hax)
M = view(hax); 
R = M(1:3,1:3); 
x = R*[1;0;0]; 
y = R*[0;1;0]; 
z = R*[0;0;1]; 
set(get(hax,'XLabel'),'rotation',360/(2*pi)*atan(x(2)+0.1/x(1))) 
set(get(hax,'YLabel'),'rotation',360/(2*pi)*atan(y(2)/y(1))) 
set(get(hax,'ZLabel'),'rotation',360/(2*pi)*atan(z(2)/z(1)))