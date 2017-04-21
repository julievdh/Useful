function ab = BrokenStickRegression(xx, yy, nstick, weights)
%BROKENSTICKREGRESSION  piecewise linear regression. Fits a line
% consisting of connected straight sections to a cloud of data points.
%
% AB = BrokenStickRegression(XX, YY, NSTICK); XX and YY are vectors of 
% the data points; NSTICK is the number of connected straight sections. 
% AB(:, 1) are the x-coordinates of endpoints and breakpoints in 
% ascending order. AB(:, 2) are the corresponding y-coordinates. XX need
% not be in monotonic order.
%
% AB = BrokenStickRegression(XX, YY, BREAKPOINTS); BREAKPOINTS is either
% a vector of at least two abscissa values chosen as starting 
% breakpoints or one non-integer starting breakpoint on the abscissa.
% NUMEL(BREAKPOINTS) + 1 is the number of straight sections of the 
% fitting curve. Choosing starting breakpoints helps in some cases to 
% obtain better fits.
%
% AB = BrokenStickRegression( ..., WEIGHTS); WEIGHTS is a vector of
% optional weights. Its length is the same as the length of XX or YY. 
% Assigning a large weight to a data point forces the regression line to
% pass this point very closely. The coordinates of such a fixpoint as 
% well as its weight can be appended to the respective vectors XX, YY, 
% and WEIGHTS.
%
% Example 1:
% ---------
%    nstick = 4;
%    nn = 800;
%    xx = linspace(1.0, 11.5, nn)';
%    y0 = sin(xx);
%    yy = y0 + randn(nn, 1) * 0.4;
%    ab = BrokenStickRegression(xx, yy, nstick);
%    plot(xx, yy, 'b.', xx, y0, 'k', ab(:, 1), ab(:, 2), 'r-o')
%    title(['BrokenStickRegression(x, sin(x) + noise, ', ...
%          int2str(nstick), ')'])
%
% Example 2:
% ---------
%   xx = 0:100;
%   yy = [ones(1, 70), 1:10, 11:-1:0];
%   yy = [yy, zeros(1, 101 - length(yy))] + 0.8 * randn(1, 101);
%   bp = [65, 75, 90];                     % breakpoints.
%   plot(xx, yy, '.')
%   hold on
%   ab1 = BrokenStickRegression(xx, yy, numel(bp) + 1);
%   plot(ab1(:, 1), ab1(:, 2), 'k-o')
%   ab2 = BrokenStickRegression(xx, yy, bp);
%   plot(ab2(:, 1), ab2(:, 2), 'r-o')
%   legend('data points', 'NSTICK scalar', 'NSTICK vectorial', ...
%      'Location', 'NW')
%
% Example 3:
% ---------
%    nstick = 4;
%    nn = 80;
%    xx = linspace(1.0, 11.5, nn)';
%    y0 = sin(xx);
%    yy = y0 + randn(nn, 1) * 0.4;
%    wt = ones(size(xx));
%    wt(40) = 1e4;
%    ab = BrokenStickRegression(xx, yy, nstick, wt);
%    plot(xx, yy, 'b.', xx, y0, 'k', ab(:, 1), ab(:, 2), 'r-o')
%    hold on
%    plot(xx(40), yy(40), 'ko')
%    title(['BrokenStickRegression(x, sin(x) + noise, ', ...
%          int2str(nstick), 'weights'])
%

% The algorithm uses POLYFIT and FMINSEARCH.
%
% pmwnave@yahoo.de
% 2010-11-05, started. Submitted to FEX on 2010-11-13, #29387.
% 2010-12-01, case recognized in which polyfit is supplied with only one
%             data point; case recognized in which the first breakpoint 
%             slips to the left of the minimum data point. Both bugs
%             were discovered by Carlos Romero, EPFL, Lausanne. Thanks!
% 2010-12-07, penalty scheme simplified.
% 2011-09-04, one breakpoint can now be specified, as suggested by Atul
%             Ingle on 2011-09-01.
% 2013-11-04, weighting introduced.
%----------------------------------------------------------------------O
  xx = xx(:);
  yy = yy(:);  
  a0 = [];

  if numel(xx) ~= numel(yy),
     error(' ### %s: XX and YY are not equally long.', mfilename)
  end
  if ~all(isfinite(xx)) || ~all(isfinite(yy)),
     error(' ### %s: XX or YY contain non-finite elements.', mfilename)
  end
  if (nargin == 2) || isempty(nstick),
     nstick = 1;
  end
  if numel(nstick) > 1 || round(nstick) ~= nstick,
     a0 = nstick;
     nstick = numel(a0) + 1;
  end
  if numel(xx) < nstick + 1,
     error(' ### %s: too few data points.', mfilename)
  end
  weighted = (nargin > 3) && (numel(weights) == numel(xx));
  if weighted,
%
% Two adjacent weights are considered to be equal if they differ by less
% than TOLWT.
%
     tolwt    = 100 * eps;
     weights  = weights(:);
     weighted = any(abs(diff(weights)) > tolwt); 
  end
%
% Initialize the coordinates AB of the end- and breakpoints. 
%
  ab         = zeros(nstick + 1, 2);
  ab(1, 1)   = min(xx);
  ab(end, 1) = max(xx);
    
  if nstick == 1,
%
% Normal linear regression.
%
     if ~weighted,
        pp = polyfit(xx, yy, 1); 
     else
        pp = WeightedFit(xx, yy, weights);     % subfunction.
     end
     ab(:, 2) = pp(1) * ab(:, 1) + pp(2);
         
  else                                   % NSTICK > 1.    
%
% Two or more sticks. Find the breakpoints that minimize the residuals. 
% The appropriate function would be FMINCON which is part of the 
% optimization toolbox, which not everybody owns. A work-around consists
% in applying penalties whenever constraints are violated. The penalties
% are defined in MinRes. A and B define constraints: A solution point X
% is admissible if A * X < B. a0 is(are) the start point(s) of the 
% search process.
%
     A = zeros(nstick, nstick - 1);
     A(1:nstick + 1:end) = -1;             
     A(2:nstick + 1:end) =  1;
     B = zeros(nstick, 1);
     B(1)      = -ab(1, 1);
     B(nstick) =  ab(end, 1);
     
     if isempty(a0),                     % default x-coord. of corners.
        a0 = (ab(end, 1) - ab(1, 1)) / nstick * (1:nstick - 1)' + ...
             ab(1, 1);
     end
     aa = fminsearch(@MinRes, a0);
  end

function rr = MinRes(aa)                 % nested function.
%MINRES  calculates the residuals RR for given breakpoints AA.

%----------------------------------------------------------------------O
  ab(2:nstick, 1) = aa;
%
% Impose a penalty for violating constraining conditions. This approach
% can possibly be improved. Other constraints may be added as penalties.
%
  if nstick > 2 && any(A * ab(2:nstick, 1) >= B),
     rr = 1e10; 
     return
  end
%
% Regression on the leftmost section.
%
  kk = find(xx <= ab(2, 1));
  kt = numel(kk);
  if kt == 1,
     tmp = 0;
  else
     if ~weighted,
        [pp, ss, mu] = polyfit(xx(kk), yy(kk), 1);
        ab(1:2, 2)   = polyval(pp, ab(1:2, 1), [], mu);
        tmp          = yy(kk) - polyval(pp, xx(kk), [], mu);
     else
        pp           = WeightedFit(xx(kk), yy(kk), weights(kk)); % subf.
        ab(1:2, 2)   = polyval(pp, ab(1:2, 1));
        tmp          = yy(kk) - polyval(pp, xx(kk));
     end
  end
%
% All other sections.
%
  for ii = 2:nstick,
     kk = find((xx > ab(ii, 1)) & (xx <= ab(ii + 1, 1)));
     lh = xx(kk) - ab(ii, 1);
     if ~weighted,
        rh = (yy(kk) - ab(ii, 2)) * (ab(ii + 1, 1) - ab(ii, 1)) + ...
             ab(ii, 2) * lh;
        ab(ii + 1, 2) = lh' * rh / (lh' * lh);
        slope = (ab(ii + 1, 2) - ab(ii, 2)) / ...
                (ab(ii + 1, 1) - ab(ii, 1));
     else
        slope = (weights(kk)' .* (yy(kk)' - ab(ii, 2))) * xx(kk) / ...
                ((weights(kk)' .* lh') * xx(kk));
        ab(ii + 1, 2) = slope * (ab(ii + 1, 1) - ab(ii, 1)) + ab(ii, 2);
     end
     tmp   = [tmp; yy(kk) - slope * (xx(kk) - ab(ii, 1)) - ab(ii, 2)];  
  end
  rr = tmp' * tmp;
end % MinRes.
end % BrokenStickRegression.

function pp = WeightedFit(xx, yy, weights)
%WEIGHTEDFIT.

%----------------------------------------------------------------------O 
  aa = [xx, ones(size(xx))]';
  wa = [weights .* xx, weights];
  pp = inv(aa * wa) * aa * (weights .* yy);
end % WeightedFit.
% EoF BrokenStickRegression.
