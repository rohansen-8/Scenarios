function [tds] = computeTotalDegrees(d, n)

%% ------------------------------------------------------------------------
%
% Computes the exponents of all total degree n polynomials in 
% d dimensions sorted wrt 1) their total degree and 2) lexicographically
%
%% ------------------------------------------------------------------------

%% enumerate exponents of polynomials using a tensor product construction
A = (MXsparseIndexSet(d, n))';
tds = A ;
end
