%% ------------------------------------------------------------------------
%
% Plot for comparison of Mean Returns vs CVaR of losses 
%
%% ------------------------------------------------------------------------

clear ;
close all ;

train = readmatrix("CVaR_train.txt") ;
test = readmatrix("CVaR_test.txt") ;
equal = readmatrix('CVaR_equal.txt') ; 


x_train = train(:, 4) ;  y_train = train(: , 3) ;   c_train = 1 - train(: , 2) ;
x_test = test(:, 4) ;  y_test = test(: , 3) ;   c_test = 1 - test(:, 2) ;
x_equal = equal(:, 4) ;  y_equal = equal(: , 3) ;   c_equal = 1 - equal(:, 2) ;

% plot
tiledlayout(1,3) ;
C = parula(3) ;

ax = nexttile ;
ax.XGrid = 'on' ;
ax.YGrid = 'on' ;
s1 = scatter(x_train, y_train, 50, c_train, 'filled') ;
colormap(C) ;
c1 = colorbar() ;
title('Training Samples', "Interpreter", 'latex') ;

ylabel(c1, "Level (\%)", "Interpreter", 'latex') ;
ylabel(" Mean Returns (\%)", "Interpreter", 'latex') ; 
xlabel("Conditional Value at Risk (\%)", "Interpreter", 'latex') ;
copygraphics(ax, 'BackgroundColor', 'none', 'ContentType', 'vector','Resolution','600') ;

ax = nexttile ;
ax.XGrid = 'on' ;
ax.YGrid = 'on' ;
s2 = scatter(x_test, y_test, 50, c_test, 'filled') ;
colormap(C) ;
c2 = colorbar() ;
title('Testing Samples (Optimized Portfolios)', "Interpreter", 'latex') ;

ylabel(c2, "Level (\%)", "Interpreter", 'latex') ;
ylabel("Mean Returns (\%)", "Interpreter", 'latex') ;
xlabel("Conditional Value at Risk (\%)", "Interpreter", 'latex') ;
copygraphics(ax, 'BackgroundColor', 'none', 'ContentType', 'vector','Resolution','600') ;

ax = nexttile ;
ax.XGrid = 'on' ;
ax.YGrid = 'on' ;
s3 = scatter(x_equal, y_equal, 50, c_equal, 'filled') ;
c3 = colorbar();
title('Testing Samples (Equally Weighted Portfolios)', "Interpreter", 'latex') ;
ylabel(c3, "Level (\%)", "Interpreter", 'latex') ;
ylabel("Mean Returns (\%)", "Interpreter", 'latex') ;
xlabel("Conditional Value at Risk (\%)", "Interpreter", 'latex') ;
copygraphics(ax, 'BackgroundColor', 'none', 'ContentType', 'vector','Resolution','600') ;