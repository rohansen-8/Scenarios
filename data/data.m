function [X] = data(dimension, mixtures, lb, ub, N, varargin)

%% ------------------------------------------------------------------------
%                   
% Generates N random samples from multivariate Gaussian mixture distribtuions
% given the dimension, number of mixtures, the bounds for the individual
% mean vectors of the mixtures. The covariance matrices for the mixture 
% distributions can be either:
% (1) random p.d. matrices with N(1, 1)-distributed eigenvalues, or
% (2) identity matrix (unit covariance) 
% and the mixture weights can be either
% (1) random (convex) weights, or (2) equal
%
%% ----------------------- Optional Parameters ----------------------------
%
% 'covariance' - {true: random covariance
%                 default: unit covariance}
%
% 'weights' - {true: random weights 
%              default: equal weights}
%
%% ------------------------------------------------------------------------

%% specifications
d = dimension ; 

p = inputParser ;
addParameter(p, 'covariance', false, @islogical) ;
addParameter(p, 'weights', false, @islogical) ;
parse(p, varargin{:}) ;

flag1 = p.Results.covariance ;
flag2 = p.Results.weights ;

if flag1   

    % compute random covariances of mixtures
    for i = 1 : mixtures
        Q = orth(randn(d)) ;
        D = abs(diag(randn(d,1) + 1)) ;
        S = Q * D * Q' ;
        sigma_random(:, :, i) = S ;
    end

else

    % compute unit covariances of mixtures
    for i = 1 : mixtures
        sigma_unit(:, :, i) = eye(d) ;
    end

end

if flag2 

    % compute random mixing weights of the mixtures
    p = rand(mixtures, 1) ;
    p = p./sum(p) ;

end
               
% compute the mean vectors of the mixtures
mu = (ub - lb) .* rand(mixtures, d) + lb ;


%% generate random samples from the four cases
caseValue = flag1 * 2 + flag2 ;

switch caseValue

    case 3     
        % random covariances and random weights of mixtures
        gm = gmdistribution(mu, sigma_random, p) ;
        rng('default') ;
        X = random(gm, N) ;

    case 2
        % random covariances and equal weights of mixtures
        gm = gmdistribution(mu, sigma_random) ;
        rng('default') ;
        X = random(gm, N) ;

    case 1
        % unit covariances and random weights of mixtures
        gm = gmdistribution(mu, sigma_unit, p) ;
        rng('default') ;
        X = random(gm, N) ;

    case 0
        % unit covariances and equal mixing proportions
        gm = gmdistribution(mu, sigma_unit) ;
        rng('default') ;
        X = random(gm, N) ;

end

end