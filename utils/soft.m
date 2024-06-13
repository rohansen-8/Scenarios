function y = soft(x,T)

%% ------------------------------------------------------------------------
%
%  Computes the soft thresholding function, which is the proximal operator
%  of the l_1 norm function
%
%% ------------------------------------------------------------------------ 

y = max(abs(x) - T, 0) ;
y = sign(x) .* y ;

end
