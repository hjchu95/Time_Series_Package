function plot_yyaxis(left_data, right_data, xtick_pos, xtick_labels, plt_title, legend_labels, option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting time series variables using two different y axes

% Args:
%   left_data: data for left y axis
%   right_data: data for right y axis
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
% July 8th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Left axis
[T1,K1] = size(left_data);
x = 1:T1;
ax1 = axes('Position',[0.1 0.15 0.8 0.75]);
hold(ax1, 'on')
lines_left = gobjects(1, K1);
for k = 1:K1
    lines_left(k) = plot(ax1, x, left_data(:,k), 'LineWidth', 2);
end
ax1.YColor = 'k';
axis(ax1, get_axis_range(left_data));
grid(ax1, 'on')
set(ax1, 'Box', 'off')

ylims = ylim(ax1);
xlims = xlim(ax1);
line(xlims, [ylims(2) ylims(2)], ...
    'Color', [0.2 0.2 0.2], 'LineWidth', 0.5, 'Parent', ax1)

% Right axis
[T2,K2] = size(right_data);
x = 1:T2;
ax2 = axes('Position', get(ax1, 'Position'), ...
    'Color', 'none', ...
    'YAxisLocation', 'right', ...
    'XAxisLocation', 'bottom', ...
    'XColor','k','YColor','k');
hold(ax2,'on')
lines_right = gobjects(1,K2);
for k = 1:K2
    lines_right(k) = plot(ax2,x, right_data(:,k), 'LineWidth', 2);
end
axis(ax2, get_axis_range(right_data));
ax2.XTickLabel = [];
ax2.XTick = [];

% Set X ticks
linkaxes([ax1, ax2], 'x');
xticks(ax1,xtick_pos);
xticklabels(ax1,xtick_labels)

% Title
if option == 0
    plt_title = [];
elseif option == 1
    title(plt_title, 'FontSize', 20, 'Interpreter', 'latex')
else
    disp("Incorrect option. option must be either 0 (omit title) or 1 (add title).")
end

% Legend
legend([lines_left, lines_right],legend_labels, ...
    'Location','north','Orientation','horizontal');

% Set Color of Plots
default_colors = get(groot, 'defaultAxesColorOrder');

if size(default_colors,1) < K1 + K2
    default_colors = repmat(default_colors, ceil((K1 + K2)/size(default_colors,1)), 1);
end

set(ax1, 'ColorOrder', default_colors(1:K1, :), 'NextPlot', 'replacechildren');
set(ax2, 'ColorOrder', default_colors(K1+1:K1+K2, :), 'NextPlot', 'replacechildren');
