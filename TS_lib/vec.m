function [out] = vec(X)
% =========================================================================
% DESCRIPTION
% Vectorize Matrix (of vector)

% -------------------------------------------------------------------------
% INPUT AND OUTPUTS
% Args:
%   X: Objective to vectorize

% Returns:
%   out: vectorized vector

% -------------------------------------------------------------------------
% NOTES
% - reshape(X,A,B) reshapes matrix X into a A*B matrix
% - reshape(X,A,1) vectorizes matrix X into a A*1 vector

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% March 30th, 2025
% =========================================================================
[r,c] = size(X);
rc = r*c; % dimension of matrix X

vecX = reshape(X,rc,1); % rc by 1
out = vecX;