% ISWITHIN True for those elements of A that are within 
% the boundaries defined by nx2 matrix B
%
% ISWITHIN(A,B) will return 1 for each element of A that 
% is within the limits defined by the rows of matrix B
%
% If B is a two-element row vector, ISWITHIN(A(i,j),B) is true if
%               B(1) < A(i,j) <= B(2)
%
% If B is a two-column matrix, ISWITHIN(A,B) will be true for all those 
% elements within A that are within the limits of any row vector in B
%
% [X,N] = ISWITHIN(A,B) where B is an nx2 matrix of non-overlapping limits
% will return matrices X and N equal to the size of matrix A, where X(i,j) 
% is true if A(i,j) is within the boundaries of any row vector in B, 
% and where N(i,j) is 0 if A(i,j) is outside limits defined by B,
% and is otherwise equal to the row number "k" where 
%               B(k,1) < A(i,j) =< B(k,2) 
%
% Frants.Jensen@gmail.com

function [X,N] = iswithin(A,B)

nlim=size(B,1);

if nargout>2,
    error('Too many output arguments requested')
elseif nargout==2
    % Check if any limits overlap and abort if they do
    for k=1:nlim,
        a=B(k,1)<B(setdiff(1:nlim,k),2);
        b=B(k,1)>B(setdiff(1:nlim,k),1);
        if any(a.*b)
            error('Overlapping limits not allowed with two output arguments')
        end
    end
end
    
X=zeros(size(A));
N=zeros(size(A));

for k=1:nlim,
    a = A<=B(k,2);
    b = A>B(k,1);
    X(find(a.*b))=1;
    N(find(a.*b))=k;
end