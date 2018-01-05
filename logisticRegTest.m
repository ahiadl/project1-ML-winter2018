function [y] = logisticRegTest(X, teta)
    N = size(X,2);
    y = zeros([N 1]);
    g = 1./(1+exp(-teta(:)'*X));
    y(g>0.5) = 1;
end

