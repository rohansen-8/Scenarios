function [x] = ADMM(A,y)

%% ---------------------------- ADMM --------------------------------------
% Solves the following optimization  problem 
%          min  (1/2) ||Ax - y||^2_2
%           s.t. 1) POSITIVITY:  x >= 0
%                2) ADD-TO-ONE:  sum(x) = 1
%
%% ------------------------------------------------------------------------ 

%% initialization
N = size(A, 2) ;
lambda = ones(N, 1) ;
tol = 1e-10 ;
iters = 250 ;

%% rescaling
A_m = mean(A, 2) ;
A = A - A_m * ones(1, N) ;
y = y - A_m ;
norm_y = norm(y) ;
A = A/norm_y ;
y = y/norm_y ;
lambda = lambda / (norm_y^2) ;


%% other variables
a = ones(N, 1) ;
mu = 10 * mean(lambda) + 0.01 ;
[U, S] = svd(A' * A, 'econ') ;                          % B = (A' * A + mu * I)
s = diag(S) ;
inv_B = U * diag(1./(s + mu)) * U' ;
C = (inv_B * a) / (a' * inv_B * a) ;              
D = (inv_B - C * a' * inv_B) ;
b = A' * y ;

%% ADMM algorithm
u = 0 ;
d = 0 ;
tol_1 = sqrt(N) * tol ;
tol_2 = sqrt(N) * tol ;
res_p = inf ;
res_d = inf ;

k = 1 ;
mu_changed = 0 ;

%% main iteration
while ((k <= iters) && ((abs(res_p) > tol_1) || (abs(res_d) > tol_2)))    

    if mod(k, 10) == 1
        u0 = u ;
    end

    w = b + mu * (u + d) ;
    x = D * w + C ;
    u = soft(x - d, lambda/mu) ;     % soft thresholding
    u_pos = (u >= 0) ;
    u = u .* u_pos ; 
    d = d - (x - u) ;

    % update mu so to keep primal and dual residuals within a factor of 10
    if mod(k,10) == 1

        res_p = norm(x - u) ;
        res_d = mu * norm(u - u0) ;
        
        % update mu
        if res_p > 10 * res_d
            mu = mu * 2 ;
            d = d/2 ;
            mu_changed = 1;
        elseif res_d > 10 * res_p
            mu = mu/2 ;
            d = d * 2 ;
            mu_changed = 1 ;
        end
        if  mu_changed
            inv_B = U * diag(1 ./ (s + mu)) * U' ;
            C = (inv_B * a) / (a' * inv_B * a) ;              
            D = (inv_B - C * a' * inv_B) ;
            mu_changed = 0 ;
        end
    end

    k = k + 1 ;   
end

end