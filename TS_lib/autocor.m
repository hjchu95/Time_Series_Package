function [corr, bound] = autocor(X,taumax,is_plot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimating the Autocorrelation function (ACF) of a univariate process and
% testing a single hypothesis for a White-noise test.

% Args:
%   X: Objective of estimation (univariate)
%   taumax: Maximum time lag (default = 20)
%   is_plot: Option to control for the figure
%       0 = omit figure
%       1 = plot figure

% Returns:
%   corr: Estimated autocovariance function, taumax+1 by 1
%   bound: 2 standard error limits, Box et. al. (2015) pp. 33.

% Written by Hyun Jae Stephen Chu
% August 7th, 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2 || isempty(taumax)
    taumax = 20;
end

if nargin < 3 || isempty(is_plot)
    is_plot = 0;
end

[T,k] = size(X);

if k > 1
    disp('Warning: X should be a column vector')
    return
else
    cov = autocov(X,taumax);
    corr = cov/cov(1,1);
end

bound = [2*sqrt(1/T), -2*sqrt(1/T)]; % 2 standard error limits, Box et. at. (2015) pp. 33

if is_plot == 1
    figure
    stem((0:rows(corr)-1)', corr, 'filled', '-o', 'MarkerSize', 4, 'SeriesIndex' ,2, 'Tag', 'ACF')
    title('Sample Autocorrelation Function', 'FontSize', 20, 'interpreter', 'latex')
    xlabel('Lag', 'FontSize', 15, 'interpreter', 'latex')
    ylabel('Sample Autocorrelation', 'FontSize', 15, 'interpreter', 'latex')
    hold on
    yline(bound(:,1), '-b')
    yline(bound(:,2), '-b')
    grid on
end

end