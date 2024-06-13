cd samples;
X = readmatrix('data_2_5_1.txt') ;
cd '/Users/rohan.sen/Desktop/GITHUB/Scenarios/scenarios';

N = 10^(4) ;
X = X(randperm(100000, N), : ) ;
[N, ~] = size(X) ; 
q = 1 ;
tol = 1e-6 ;
V = vandermonde(X, 2 * q) ;
D = ones(N,1) ./ N ;
y = V' * D ;