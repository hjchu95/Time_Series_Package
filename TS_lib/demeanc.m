function retf = demeanc(x)
% Demeaning x

[T,~] = size(x);
x_ = mean(x);
retf = x - ones(T,1)*x_;

end