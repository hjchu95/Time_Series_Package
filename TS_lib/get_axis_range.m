function ax = get_axis_range(y,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deriving the range of axis

% Args:
%   y: Input variable (matrix)
%   n: Number of variables

% Returns:
%   ax: Range of the axis

% Written by Hyun Jae Stephen Chu
% July 7th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
    n = rows(y);
end

max_val = max(y, [], 'all', 'omitnan');
min_val = min(y, [], 'all', 'omitnan');

if min_val < 0
    q1 = 1.1;
else
    q1 = 0.9;
end

y_min = q1 * min_val;
y_max = 1.1 * max_val;

ax = [1 n y_min y_max];