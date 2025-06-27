function B0inv = B0invSolve(A_hat, Sigma_hat, restrict)
% =========================================================================
% DESCRIPTION
% Identifying the B0 inverse matrix of the structural-form VAR(p) model
% using either 'short-run' or 'long-run' restriction

% -------------------------------------------------------------------------
% INPUT AND OUTPUTS
% Args:
%   A_hat: Estimated coefficient matrix of reduced-form VAR(p) model
%   Sigma_hat: Estimated variance-covariance matrix of reduced-form VAR(p)
%   model
%   restrict: Identification method to use
%       (1) short = Short-run, recursive restriction
%       (2) long = Long-run restriction

% Returns:
%   B0inv: Identified B0 inverse matrix of the structural-form VAR(p) model

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% March 30th, 2025
% =========================================================================
SIG = Sigma_hat;

switch restrict

    % 1. Short-run identification
    case 'short'
        B0inv = chol(SIG)';
        % chol(A) is a upper-triangular matrix.
        % -> Transpose is needed to obtain the lower-triangular matrix

    % 2. Long-run identification
    case 'long'
        A = A_hat';
        [K,n] = size(A);
        p = n/K;
        A1 = eye(K);

    % 3. If not 'short' or 'long'
    otherwise
        warning('Unexpected Restriction. Restrict must be either (short) or (long).')

end

end