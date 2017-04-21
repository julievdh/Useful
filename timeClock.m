function timeClock(h,m,s)
% Display the time h:m:s on a clock with hour and minute hands.
% Hour h may be in 12- or 24-hour clock format, i.e., range is [0..24].
% Minute m and second s are in the range [0..59].


drawClockFace('d','.');

% Draw hour hand
hours= h + m/60 + s/3600;
hourAngle= 90 - hours*(360/12);
% compute coordinates for pointing end of hour hand and draw it
[xhour, yhour]= polar2xy(0.6, hourAngle);
plot([0 xhour], [0 yhour], 'r-','linewidth',5)

% Draw minute hand
mins= m + s/60;
minsAngle= 90 - mins*(360/60);
% compute coordinates for pointing end of minute hand and draw it
[xmins, ymins]= polar2xy(0.8, minsAngle);
plot([0 xmins], [0 ymins], 'm-','linewidth',5)
