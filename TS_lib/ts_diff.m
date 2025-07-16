function dy = ts_diff(y,option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transformation of the variable by differencing

% Args:
%   y: Input variable (multivariate)
%   option: Method of transformation
%       qoq_diff = Quarter-on-quarter differencing, dy_{t} = y_{t} - y_{t-1}
%       yoy_diff = Year-on-year differencing, dy_{t} = y_{t} - y_{t-4}
%       qoq_gr = Quarter-on-quarter growth rate, dy_{t} = log(y_{t}) - log(y_{t-1})
%       yoy_gr = Year-on-year growth rate, dy_{t} = log(y_{t}) - log(y_{t-4})

% Returns:
%   dy: Output variable (percent change of y)

% Written by Hyun Jae Stephen Chu
% July 12th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[T,K] = size(y);

switch option

    case 'qoq_diff'
        dy = zeros(T-1,K);
        for k = 1:K
            for t = 1:T-1
                dy(t,k) = y(t+1,k) - y(t,k);
            end
        end

    case 'yoy_diff'
        dy = zeros(T-4,K);
        for k = 1:K
            for t = 1:T-4
                dy(t,k) = y(t+4,k) - y(t,k);
            end
        end

    case 'qoq_gr'
        dy = zeros(T-1,K);
        for k = 1:K
            for t = 1:T-1
                dy(t,k) = log(y(t+1,k)) - log(y(t,k));
            end
        end
        dy = dy*100;

    case 'yoy_gr'
        dy = zeros(T-4,K);
        for k = 1:K
            for t = 1:T-4
                dy(t,k) = log(y(t+4,k)) - log(y(t,k));
            end
        end
        dy = dy*100;

    otherwise
        disp("Incorrect option number. option must be (qoq_diff), (yoy_diff), (qoq_gr), or (yoy_gr).")
end