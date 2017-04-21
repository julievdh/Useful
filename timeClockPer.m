function timeClockPer(t1,t2,rad,alpha)
% Display the time h:m:s on a clock with hour and minute hands.
% Hour h may be in 12- or 24-hour clock format, i.e., range is [0..24].
% Minute m and second s are in the range [0..59].

% time 1 = hour minute; time 2 = hour minute

% drawClockFace('d','.'); hold on

% Get hours and minutes of time inputs
h1 = t1(1); m1 = t1(2);
h2 = t2(1); m2 = t2(2);

% Draw hour 1 hand
hours = h1 + m1/60;
hourAngle1 = 90 - hours*(360/24);
% compute coordinates for pointing end of hour hand and draw it
%[xhour1, yhour1]= polar2xy(0.6, hourAngle1);
%plot([0 xhour1], [0 yhour1], 'r-','linewidth',5)

% Draw hour 2 hand
hours = h2 + m2/60;
hourAngle2 = 90 - hours*(360/24);
% compute coordinates for pointing end of hour hand and draw it
%[xhour2, yhour2]= polar2xy(0.6, hourAngle2);
%plot([0 xhour2], [0 yhour2], 'k-','linewidth',5)

plot_arc(deg2rad(hourAngle1),deg2rad(hourAngle2),0,0,rad,alpha)
