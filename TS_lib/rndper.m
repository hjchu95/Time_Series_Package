function [retf] = rndper(y)
% =========================================================================
% DESCRIPTION
% Randomly permute a sequence of numbers

% -------------------------------------------------------------------------
% INPUT AND OUTPUTS
% Args:
%   y: Sequence that is inputted

% Returns:
%   retf: Randomly permuted sequence

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% March 30th, 2025
% =========================================================================

n = length(y); % number of elements in sequence y

z = y;
k = n;
while k > 1
    ind = ceil(rand(1,1)*k); % index of random element
    zi = z(ind,:); % random element of y
    zk = z(k,:); % last element of y
    
    % /* interchanging values */
    z(ind,:) = zk;
    z(k,:) = zi;
    k = k-1;
end

retf = z;

end