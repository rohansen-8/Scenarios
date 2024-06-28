function [VaR_value] = VaR(returns, level)

%% ------------------------------------------------------------------------
% 
% Calculates the VaR for the losses given a confidence level
% 
%% ------------------------------------------------------------------------

losses = - returns ;
sorted_losses = sort(losses, 'descend') ;
index = ceil(level * length(sorted_losses)) ;
VaR_value = sorted_losses(index) ;

end


