function [L, B] = PivotedCholesky(M, tol)

%% --------------------------- Pivoted Cholesky ---------------------------
%
% Constructs the pivoted Cholesky decomposition of the matrix M ~ LL'
% and biorthogonal basis B within a relative threshold of tolerance 
% s.t. L'B = B'L = I
%
%% ------------------------------------------------------------------------

%% initialization
d = diag(M) ;
tr = sum(d) ;
tol = tol * tr ;
L = [] ;
B = [] ;

%% main loop
while (tr > tol)
    [~, piv] = max(d) ;

    if (d(piv) <= 0)
        break ;
    end
    
    L(:, end + 1) = M(: , piv) ;
    B(:, end + 1) = zeros(length(d), 1) ;
    B(piv, end) = 1 ;
    row = L(piv, 1 : end - 1)' ;
    L(:, end) = L(:, end) - L(:, 1 : end - 1) * row ;
    B(:, end) = B(:, end) - B(:, 1 : end - 1) * row ;
    factor = 1 ./ sqrt(L(piv, end)) ;  
    L(:, end) = L(:, end) * factor ;
    B(:, end) = B(:, end) * factor ;
    d = d - L(:, end) .* L(:, end) ;
    tr = sum(d) ;
end
end

