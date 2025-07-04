function dy = pc_diff(y,option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deriving the percent change of variable by YoY or QoQ

% Args:
%   y: Input variable (univariate)
%   option: Method of deriving the percent change
%       1 = Year-on-year, dy_{t} = log(y_{t}) - log(y_{t-4})
%       2 = Quarter-on-quarter, dy_{t} = log(y_{t}) - log(y_{t-1})

% Returns:
%   dy: Output variable (differenced y)

% Written by Hyun Jae Stephen Chu
% July 4th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[T,~] = size(y);

% 1. YoY
if option == 1
    dy = zeros(T-4,1);
    for t = 1:T-4
        dy(t,1) = log(y(t+4,1)) - log(y(t,1));
    end
    dy = dy*100;

% 2. QoQ
elseif option == 2
    dy = zeros(T-1,1);
    for t = 1:T-1
        dy(t,1) = log(y(t+1,1)) - log(y(t,1));
    end
    dy = dy*100;

else
    disp("Incorrect option number. option must be either 1 or 2.")
end