function [H] = Householder(X, v)

%% ------------------------------------------------------------------------

% Calculates the Householder reflector H such that Hv = -v and Hw = w

%% ------------------------------------------------------------------------

gamma = 2/norm(v)^2 ;
u = gamma * v' ;
u = u * X ;
X = X - v * u ;
H = X ;

end