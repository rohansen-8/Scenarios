function [L, B, ind] = OMP(Q, h, max_iter)

%% -------------------------------- OMP -----------------------------------
%
% Identifies the scenarios from the linear system Kw = h, where K = QQ'
% by constructing a low-rank approximation K ~ LL' and biorthogonal basis B
% s.t. L'B = B'L = I
%
%% ------------------------------------------------------------------------

%% initialization
N = size(Q, 1) ;
tol = 1e-6 ;
err = 1 ;
tol = tol * err ;
h0 = h ;
d = zeros(N, 1) ;
for i = 1 : N
    d(i,1) = Q(i, :) * Q(i, :)' ;
end

L = zeros(N, max_iter) ;
B = zeros(N, max_iter) ;
ind = zeros(max_iter) ;
k = 1 ;

%% main loop
while ((k <= max_iter) && (err > tol))

    [~, piv] = max(abs(d)) ;

     if (d(piv) <= 0)
        break ;
     end

    L(:, k) = Q * Q(piv, :)' ;
    factor = 1./sqrt(L(piv, k)) ;
    B(piv, k) = 1 ;

    if k > 1
        row = L(piv, 1 : k-1)' ;
        L(:, k) = L(:, k) - L(:, 1 : k-1) * row ;
        B(:, k) = B(:, k) - B(:, 1 : k-1) * row ;
    end

    L(:, k) = L(:, k) * factor ;
    B(:, k) = B(:, k) * factor ;
    d = d - L(:, k) .* L(:, k) ;
    h = h - (B(:, k)' * h0) * L(:, k) ;
    err = norm(h)/norm(h0) ;
    ind(k) = piv ;
    k = k + 1 ;
   
end

%% return
L = L(:, 1 : k-1) ;
B = B(:, 1 : k-1) ;
ind = ind(1 : k-1) ;

end
