function plot_time_series(y, xtick_pos, xtick_labels, plt_title, legend_labels, option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting time series variables

% Args:
%   y: Input variable (multivariate)
%   xtick_pos: Position for xticks (e.g. 1:1:20)
%   xtick_labels: Labels for xticks
%   plt_title: Title for the figure
%   legend_labels: Labels for the legend
%   option: Option for Plot Title
%       0 = Omit plot title
%       1 = Add plot title

% Returns:
%   f: figure

% Written by Hyun Jae Stephen Chu
% July 7th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(y, 'LineWidth', 2)
axis(get_axis_range(y))
T = rows(y);
xticks(xtick_pos);
xticklabels(xtick_labels)

if option == 0
    plt_title = [];
elseif option == 1
    title(plt_title, 'FontSize', 20, 'Interpreter', 'latex')
else
    disp("Incorrect option. option must be either 0 (omit title) or 1 (add title).")
end

legend(legend_labels, 'Location', 'north', 'Orientation', 'horizontal')

grid on