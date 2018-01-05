function [stats] = naiveBayesTrain(X, y)
N = size(X,2);
stats.P_x_given_1_mu_ml = mean(X(:,y==1),2);
stats.P_x_given_0_mu_ml= mean(X(:,y==0),2);
d = size(X,1);
for i = 1:d
    stats.P_x_given_1_sig_ml(i) = sqrt(mean((X(i,y==1)-stats.P_x_given_1_mu_ml(i)).^2));
    stats.P_x_given_0_sig_ml(i) = sqrt(mean((X(i,y==0)-stats.P_x_given_0_mu_ml(i)).^2));
end

stats.Py_1 = sum(y==1)/N;
stats.Py_0 = 1-stats.Py_1;

end

