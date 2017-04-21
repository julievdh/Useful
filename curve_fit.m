function [a,k,Output,Correlation] = curve_fit(x,y);
% x = U;
% y = P_none(1,:);

logx=log(x);
logy=log(y);
p=polyfit(logx,logy,1);
% plot(logx,logy,'bo');
% axis equal square
% grid
% xlabel('log(x)');
% ylabel('log(y)');
k=p(1);
loga=p(2);
a=exp(loga);
% hold on; plot(logx,k*logx+loga,'g')
% legend('Data',sprintf('y=%.3f{}log(x)+log(%.3f)',k,a));
% figure
% plot(x,y,'bo');
% xlabel('x');
% ylabel('y');
% axis equal square
% grid
% hold on; plot(x,a*x.^k,'g')
% legend('Data',sprintf('y=%.3f{}x^{%.3f}',a,k));

[p, s] = polyfit(x, y, 1);
Output = polyval(p, x);
Correlation = corrcoef(y, Output);
end
