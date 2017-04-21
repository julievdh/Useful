
    x(:,2) = rostrum(:,1);
    x(:,1) = ones;
    y = rostrum(:,4);
    Sx = std(x);
    Sy = std(y);
    n = length(x);
    [b,bint,r,rint,stats] = regress(y,x);
    p(1) = stats(4); % pvalue for F statistic: is the regression significant?
    r2 = stats(1);
    yfit = b(2)*x(:,2)+b(1);
    t = b(2)*Sx(2)*sqrt(n)/(sqrt((n*Sy^2 - n*b(2)^2*Sx(2)^2)/(n-2)));
    R = corrcoef(x(:,2),y);
    coeff = R(1,2);
    p(2) = 1-tcdf(t,n); % pvalue for b: is the slope of the regression line equal to zero?