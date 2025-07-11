function save_as_html(figure,folder,filename,option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save MATLAB figure into html format file

% Args:
%   figure: Saved MATLAB figure
%   folder: Name of folder to save
%   filename: Filename to save

% Returns:
%   filename.html will be made in the ".../folder" folder

% -------------------------------------------------------------------------
% Required functions or packages:
% fig2plotly package ("https://github.com/plotly/plotly_matlab")
% -------------------------------------------------------------------------

% Written by Hyun Jae Stephen Chu
% July 8th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = fig2plotly(figure, 'offline', true, 'filename', fullfile(folder, filename), 'open', false);
if nargin == 4
p.layout.legend.orientation = 'h';
% p.layout.legend.x = 0.36;
% p.layout.legend.y = 0.84;
% p.layout.width = 700;
% p.layout.height = 450;
% p.layout.margin = struct('t', 30, 'l', 5, 'r', 5, 'b', 10);

p.layout.legend.x = option.legx;
p.layout.legend.y = option.legy;
p.layout.width = option.width;
p.layout.height = option.height;
p.layout.margin = option.margin;

end

plotlyoffline(p);