function [nodes, weights] = cov_scenarios(M, tol)

%% ------------------------------------------------------------------------
%
% Identifies the covariance scenarios and the (equal) weights corresponding
% to a moment matrix M of order 1 given a tolerance 
%
%% ------------------------------------------------------------------------

[L, ~] = pivoted_cholesky(M, tol) ;     % matrix root

l = L(1, :)' ;
r = length(l) ;
lambda = 1/sqrt(r) ;
e = ones(r, 1) ;
v = l - lambda .* e ;

H = Householder(eye(r), v) ;           % computes Householder reflection
X0 = L * H ;
X0 = X0' ;

X0 = X0/lambda ; 
X0(:, 1) = [] ;

nodes = X0 ;                           
weights = ones(r, 1) * (lambda^2) ;

end