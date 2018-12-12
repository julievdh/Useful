function [sun_rise,sun_set] = sunRiseSet( lat, lng, UTCoff, date)
%SUNRISESET Compute apparent sunrise and sunset times in seconds.
%     sun_rise_set = sunRiseSet( lat, lng, UTCoff, date) Computes the *apparent** (refraction
%     corrected) sunrise  and sunset times in seconds from mignight and returns them as
%     sun_rise_set.  lat and lng are the latitude (+ to N) and longitude (+ to E), UTCoff is the
%     local time offset to UTC in hours and date is the date in format 'dd-mmm-yyyy' ( see below for
%     an example).
% 
% EXAMPLE:
%     lat = -23.545570;     % Latitude
%     lng = -46.704082;     % Longitude
%     UTCoff = -3;          % UTC offset
%     date = '15-mar-2017';
% 
%     sun_rise_set = sunRiseSet( lat, lng, UTCoff, date);
% 
%     [sr_h, sr_m, sr_s] = hms(sun_rise_set(1));
%     [ss_h, ss_m, ss_s] = hms(sun_rise_set(2));
%
% 
% Richard Droste
% 
% Reverse engineered from the NOAA Excel:
% (https://www.esrl.noaa.gov/gmd/grad/solcalc/calcdetails.html)
% 
% The formulas are from:
% Meeus, Jean H. Astronomical algorithms. Willmann-Bell, Incorporated, 1991.

% Process input
nDays = daysact('30-dec-1899',  date);  % Number of days since 01/01
nTimes = 24*3600;                       % Number of seconds in the day
tArray = linspace(0,1,nTimes);

% Compute
% Letters correspond to colums in the NOAA Excel
E = tArray;
F = nDays+2415018.5+E-UTCoff/24;
G = (F-2451545)/36525;
I = mod(280.46646+G.*(36000.76983+G*0.0003032),360);
J = 357.52911+G.*(35999.05029-0.0001537*G);
K = 0.016708634-G.*(0.000042037+0.0000001267*G);
L = sin(deg2rad(J)).*(1.914602-G.*(0.004817+0.000014*G))+sin(deg2rad(2*J)).* ...
    (0.019993-0.000101*G)+sin(deg2rad(3*J))*0.000289;
M = I+L;
P = M-0.00569-0.00478*sin(deg2rad(125.04-1934.136*G));
Q = 23+(26+((21.448-G.*(46.815+G.*(0.00059-G*0.001813))))/60)/60;
R = Q+0.00256*cos(deg2rad(125.04-1934.136*G));
T = rad2deg(asin(sin(deg2rad(R)).*sin(deg2rad(P))));
U = tan(deg2rad(R/2)).*tan(deg2rad(R/2));
V = 4*rad2deg(U.*sin(2*deg2rad(I))-2*K.*sin(deg2rad(J))+4*K.*U.*sin(deg2rad(J)).* ...
    cos(2*deg2rad(I))-0.5.*U.*U.*sin(4*deg2rad(I))-1.25.*K.*K.*sin(2.*deg2rad(J)));
W = rad2deg(acos(cos(deg2rad(90.833))./(cos(deg2rad(lat))*cos(deg2rad(T))) ...
    -tan(deg2rad(lat))*tan(deg2rad(T))));
X = (720-4*lng-V+UTCoff*60)*60;

% Results in seconds
[~,sunrise] = min(abs(X-round(W*4*60) - nTimes*tArray));
[~,sunset] = min(abs(X+round(W*4*60) - nTimes*tArray));

% Print in hours, minutes and seconds
fprintf('Sunrise: %s  \nSunset:  %s\n', ...
    datestr(sunrise/nTimes,'HH:MM:SS'), datestr(sunset/nTimes,'HH:MM:SS'));

sun_rise = datestr(sunrise/nTimes,'HH:MM:SS');
sun_set = datestr(sunset/nTimes,'HH:MM:SS');