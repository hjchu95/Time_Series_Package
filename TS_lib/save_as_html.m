function save_as_html(figure,folder,filename)
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
p.layout.legend.orientation = 'h';
p.layout.legend.x = 0.45;
plotlyoffline(p);