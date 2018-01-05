close all;
clear all;
clc;
load('BreastCancerData.mat');
N = size(X,2);
d = size(X,1);
X = X - min(X,[],2);
X = X./repmat(max(X,[],2), 1, N);

for i = 1: numel(y)
    y_cell{i} = y(i);
end

train_precent = 0.8;
N = size(X,2);
num_train_samples= floor(train_precent*N);
rand_indx = randperm(N);
X_train = X(:,rand_indx(1:num_train_samples));
y_train = y(rand_indx(1:num_train_samples));
X_test = X(:,rand_indx(num_train_samples+1:end));
y_test = y(rand_indx(num_train_samples+1:end));

K=10; %num of groups for training
group_size = floor(num_train_samples/K);
for i =1:K-1
    mini_train_sets{i} = X_train(:,(i-1)*group_size+1:i*group_size);
    mini_y_sets{i} = y_train((i-1)*group_size+1:i*group_size);
end
mini_train_sets{K} = X_train(:,i*group_size+1:end);
mini_y_sets{K} = y_train(i*group_size+1:end);


tree = buildTree(X_train, y_train, 'Antropy') ;

for i =1:size(X_test,2)
    y_predicted(i) = testTree(tree, X_test(:,i));
end

err = 100*sum(abs(y_test-y_predicted'))/length(y_test);




