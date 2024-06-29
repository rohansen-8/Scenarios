%% ------------------------------------------------------------------------
%
% Plot for PDF of Gaussian mixture model with scenarios 
%
%% ------------------------------------------------------------------------

clear ;
close all ;

d = 2 ;                          % dimension
a = -10 ;                        % lower bound
b = 10 ;                         % upper bound
clusters = 20 ;
N = 10^4 ;
q = 2 ;

% compute means 
mu = (b-a) .* rand(clusters, d) + a ;


% compute random covariances 
for i = 1 : clusters
    Q = orth(randn(d)) ;
    D = abs(diag(randn(d, 1) + 1)) ;
    S = Q * D * Q' ;
    sigma(:, :, i) = S ;
end

% compute random mixing proportions
p = rand(clusters, 1) ;
p = p ./ sum(p) ;

% generate random samples
gm = gmdistribution(mu, sigma) ;
rng('shuffle') ;
X = random(gm, N) ;

% OMP
[ind, p] =  test_OMP(X, q) ;
X0 = X(ind, :) ;
x = X0(:,1) ;
y = X0(:,2) ;

c = sqrt(X(:,1).^2 + X(:,2).^2) ;
[weight,index]  = sort(c, 'ascend') ;
X = X(index, :) ;

% light to dark blue colormap
% number of colors
cmap = [linspace(.9,0,N)', linspace(.9447,.447,N)', linspace(.9741,.741,N)'] ; % light to dark blue colormap
cmap_inverted = flip(cmap) ; % now dark to light blue
S = (weight-min(weight))/(max(weight)-min(weight))*(N-1)+1 ;  % map to n colors

% plot 
tiledlayout(2,1) ;

ax1 =  nexttile ;
gmPDF = @(x,y) arrayfun(@(x0, y0) pdf(gm, [x0 y0]), x, y) ;
fsurf(gmPDF,[-15 15]) ;
colormap(parula) ;
colorbar() ;
box on ;
ylabel("y", "Interpreter", 'latex') ;
xlabel("x", "Interpreter", 'latex') ;
title('PDF of multivariate Gaussian mixture distribution', "Interpreter", 'latex') ;
copygraphics(ax1, 'BackgroundColor', 'none', 'ContentType', 'vector','Resolution','600') ;

ax2 = nexttile ;
scatter(X(:,1), X(:,2), 50, S, "*", 'DisplayName', 'Samples') ;
hold on

scatter(x, y, 100, 'filled', "red", 'DisplayName', 'Scenarios') ;
legend ;
set(legend, 'FontSize', 14, 'FontName', 'Times New Roman') ;
hold on

gmPDF = @(x,y) arrayfun(@(x0, y0) pdf(gm,[x0  y0]), x, y) ;
c = fcontour(gmPDF, [-15, 15], 'LineWidth', 2,'LineColor','k') ;
c.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('Random samples with contour lines and scenarios', "Interpreter", 'latex') ;
ylabel("y", "Interpreter", 'latex') ;
xlabel("x", "Interpreter", 'latex') ;
hold off

copygraphics(ax2, 'BackgroundColor', 'none', 'ContentType', 'vector','Resolution', '600') ;
