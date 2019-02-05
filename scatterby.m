function [] = scatterby(x,y,s,c)

figure(101), hold on
for i = 1:length(y)
h = scatter(x(i)+rand(1),y(i),s,'ko','markerfacecolor',c(i,:));
end