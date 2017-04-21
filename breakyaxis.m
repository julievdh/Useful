function h=BreakYAxis(x,y,start,stop,width);

% Julie Haas, after Michael Robbins
% - assumes dx is same for all data
% - 'width' must be a whole number
% - to change axis, use {a=axis} to get axis, and reset in those units

%test data:  
% x=[1:.5:40]; y=rand(size(x)); start=10;stop=20;width=6; 
% x=.01:.01:10;y=sin(6*x);start=2;stop=3;width=1;

% erase unused data
y(x>start & y<stop)=[];
x(x>start & x<stop)=[];

% map to new xaxis, leaving a space 'width' wide
y2=y;
y2(y2>=stop)=y2(y2>=stop)-(stop-start-width);

h=plot(x,y2,'.');

xtick=get(gca,'XTick');
t1=text(xtick(1),start+width/2,'//','fontsize',15);
% t2=text(start+width/2,ytick(max(length(ytick))),'//','fontsize',15);
% For y-axis breaks, use set(t1,'rotation',270);

% remap tick marks, and 'erase' them in the gap
ytick=get(gca,'YTick');
dtick=ytick(2)-ytick(1);
gap=floor(width/dtick);
last=max(ytick(ytick<=start));          % last tick mark in LH dataset
next=min(ytick(ytick>=(last+dtick*(1+gap))));   % first tick mark within RH dataset
offset=round(size(y2(y2>last&y2<next),2)*(y(2)-y(1)));

for i=1:sum(ytick>(last+gap))
    ytick(find(ytick==last)+i+gap)=stop+offset+dtick*(i-1);
end
    
for i=1:length(ytick)
    if ytick(i)>last&ytick(i)<next
        yticklabel{i}=sprintf('%d',[]);
    else
        yticklabel{i}=sprintf('%d',ytick(i));
    end
end;
set(gca,'yticklabel',yticklabel);

