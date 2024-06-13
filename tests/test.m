function [X0] = test(X, q)

%% ------------------------------------------------------------------------
% Outputs the relative error of the corresponding moment matrices (in 
% the Frobenious norm), the computation time, and the no of scenarios for 
% a given set of samples and the degree of the moments
%
%% ------------------------------------------------------------------------

tic ;

tol = 1e-6 ;
V = vandermonde(X, 2 * q) ;
N = size(X, 1) ;
e = ones(N, 1) ./ N ;
y = V' * e ;
M = V' * V / N ;                 % moment matrix of samples

% scenarios using OMP
[~, B] = PivotedCholesky(M, tol) ;
Q = 1/sqrt(N) * V * B ;
[~, ~, ind] = OMP(Q, e) ;

% weights using ADMM
V0 = V(unique(ind), :) ; 
A = V0' ;
p = ADMM(A, y) ;

ind = (p > 1e-8) ~= 0 ;     % ignore scenarios having low prob.
X0 = X(ind, :) ;                  % updated scenarios 
M_model = A * diag(p) * A' ;      % moment matrix of scenarios

% output results
fprintf("\nERROR     NO. OF SCENARIOS      TIME\n\n") ;
fprintf('%f \t %d \t %f\n\n', norm(M - M_model, "fro") / norm(M, "fro"), ...
     length(p(p > 10^(-8))), toc) ;

end