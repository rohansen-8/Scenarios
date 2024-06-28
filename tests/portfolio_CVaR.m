%% ------------------------------------------------------------------------
%
%  For 100 simulations, obtains the optimal portfolio weights that
%  maximize mean returns given CVaR constraints using OMP scenarios
%
%% ------------------------------------------------------------------------

% read data 
X = readmatrix("ff_x.txt") ; 

% default values
N = 10^4 ;
q = 1 ;

tic ;

for nSims = 1 : 100

    % split data
    idx = randperm(size(X, 1)) ;
    X_train = X(idx(1 : N), : ) ;
    X_test = X(idx(N + 1 : size(X, 1)), :) ;
   
    % framework for OMP 
    [ind, p] =  test_OMP(X_train, q) ;
 
    % optimize returns with CVaR constraints 
    portfolio_optim(nSims, ind, p, X_train, X_test) ;
    
 end

 toc ;
