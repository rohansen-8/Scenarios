function V = vandermonde(X, deg)

%% ------------------------------------------------------------------------
%
% Computes the Vandermonde matrix from the samples up to given total degree
%           
%% ------------------------------------------------------------------------

%% initialization 
[N, d] = size(X) ;
A = computeTotalDegrees(d, deg) ;       % compute indices vector
s = size(A, 1) ;
V = zeros(N, s);

%% construct Vandermonde matrix
for j = 1 : s
   V(:, j) = prod(X .^ (ones(N,1) * A(j,:)), 2) ;
end

end

