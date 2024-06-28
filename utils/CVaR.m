function [CVaR] =  CVaR(returns, level)

%% ------------------------------------------------------------------------
% 
% Calculates the CVaR for the losses given a confidence level
% 
%% ------------------------------------------------------------------------

% portfolio losses
losses = - returns ;

% sort the losses in descending order
sorted_losses = sort(losses, 'descend') ;

% calculate the VaR of the portfolio losses at the confidence level
index = ceil(level * length(sorted_losses)) ;
VaR = sorted_losses(index) ;

% calculate the CvaR as the conditional mean of the lossesabove VaR
CVaR = mean(sorted_losses(1 : index)) ;

end
