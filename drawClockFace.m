function drawClockFace(hourSymbol, minsSymbol)
% Draw a clock face where the hours and minutes are marked.
% hourSymbol, minsSymbol are CHARACTERS representing the marker type
% used in a plot statement.  Possibilities include:
%   '.'   'o'   'x'   '+'   '*'
% Type help plot in Matlab to see the list of color/marker/line options.

close all          %close all figure windows
axis([-1 1 -1 1])  %axis limits of the clock
axis square equal
hold on            %all subsequent plot commands appear on the current axes


  % Draw a square clock face (black frame) 
plot([-1 1], [1 1],'k','linewidth',5)
plot([1 1], [1 -1],'k','linewidth',5)
plot([1 -1], [-1 -1],'k','linewidth',5)
plot([-1 -1], [-1 1],'k','linewidth',5)



% Draw hour and minute marks 
theta= 0;
for k= 0:59
    [x,y]= polar2xy(0.9,theta);
    if ( mod(k,5)==0 )  % hour mark
        plot(x,y,hourSymbol)
    else                % minute mark
        plot(x,y,minsSymbol)
    end
    theta= theta + 360/60;
end
