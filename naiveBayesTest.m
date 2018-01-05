function [y_predicted, err] = naiveBayesTest(X, y, stats)
d = size(X,1);
for i = 1:d
   P_x_i_given_1(i,:) = normpdf(X(i,:),stats.P_x_given_1_mu_ml(i),stats.P_x_given_1_sig_ml(i));
   P_x_i_given_0(i,:) = normpdf(X(i,:),stats.P_x_given_0_mu_ml(i),stats.P_x_given_0_sig_ml(i));
end
P_is_1 = prod(P_x_i_given_1,1)*stats.Py_1;
P_is_0 = prod(P_x_i_given_0,1)*stats.Py_0;

y_predicted = P_is_1>P_is_0;
err = sum(abs(y' - y_predicted));

end

