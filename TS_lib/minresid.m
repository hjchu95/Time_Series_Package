% y = x*b + resid
% x and b are both integer, and resid is positive
function [x, resid] = minresid(y,b)

    x = floor(y/b);
    resid = y - x*b;
%     if resid == 0
%        resid = b;
%        x = x - 1;
%     end

end