function [] = portfolio_optim(nSims, ind, p, X_train, X_test)

    %% ------------------------------------------------------------------------
    %
    % Solves the optimization problem 
    %             min - Mu' *  w    s.t. CVaR_alpha <= delta
    % where delta is chosen to be the CVaR of the expected loss of the naive
    % portfolio rule at different levels of confidence. 
    %
    %% ------------------------------------------------------------------------
    
    X0 = X_train(ind, :) ;
    [r, d] = size(X0) ;
    w_eq = 1/d .* ones(d, 1) ;
    returns_eq = X0 * w_eq ;
    
    % equality constraints
    Aeq = [ones(1, d) zeros(1, r + 1)] ;
    beq = 1 ;
    
    % bound constraints
    ub = [ones(d, 1) ; Inf * ones(r + 1, 1)] ;
    lb = [zeros(d, 1) ; -Inf ; zeros(r, 1) ] ;
    
    % main loop for different confidence levels
    for level = [0.95 0.975 0.99]
    
        % inequality constraints
        A0 = [ones(1, d) 1  p' .* 1/(1 - level)] ;
        A1 = -[X0 ones(r, 1) eye(r)] ;
        A = [A0 ; A1] ;
    
        % calculate the CVaR for expected loss of naive portfolio rule
        delta = CVaR(returns_eq, level) ;
        b = [delta ; zeros(r, 1)] ;
    
        % initial weights 
        VaR_eq = VaR(returns_eq, level) ;
        x0 = [w_eq ; VaR_eq ; zeros(r, 1)] ;
    
        % objective function
        Mu = mean(X0, 1) ;
        objfun = @(x) - Mu * x(1 : d) ;
    
        % optimization
        options = optimoptions (@fmincon, 'Algorithm', 'interior-point', 'EnableFeasibilityMode', ...
            true,'MaxFunEvals', 100000) ;
        x = fmincon (objfun, x0, ...
            A, b, Aeq, beq, lb, ub, [], options) ;
        
        % optimal portfolio weights
        w_opt = x(1 : d) ;
    
        % training sample
        returns = X_train * w_opt ; 
        mean_returns = mean(returns) ;
        CVaR_losses = CVaR(returns, level) ;
        fid = fopen('CVaR_train.txt', 'a+') ;
        fprintf(fid, "%d\t%f\t%f\t%f\n", nSims, level, mean_returns, CVaR_losses) ;
       
    
        % testing sample
        returns = X_test * w_opt ;  
        mean_returns = mean(returns) ;
        CVaR_losses = CVaR(returns, level) ;
        fid = fopen('CVaR_test.txt', 'a+') ;
        fprintf(fid, "%d\t%f\t%f\t%f\n", nSims, level, mean_returns, CVaR_losses) ;
    
        % equally weighted portfolio returns
        returns = X_test * w_eq ;
        mean_returns = mean(returns) ;
        CVaR_losses = CVaR(returns, level) ;
        fid = fopen('CVaR_equal.txt', 'a+') ;
        fprintf(fid, "%d\t%f\t%f\t%f\n", nSims, level, mean_returns, CVaR_losses) ;
        
    end
    
    end