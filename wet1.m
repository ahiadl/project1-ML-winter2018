close all;
clear all;
clc;
%% PCA graph 0
load('BreastCancerData.mat');
N = size(X,2);
d = size(X,1);
X = X - min(X,[],2);
X = X./repmat(max(X,[],2), 1, N);

coeff = pca(X');
dim1 = coeff(:,1);
dim2 = coeff(:,2);

X1pca = dim1'*X;
X2pca = dim2'*X;

figure()
plot(X1pca(y==1),X2pca(y==1),'r+')
hold on 
plot(X1pca(y==0),X2pca(y==0),'b+')
xlabel('PCA 1st strong dimension')
ylabel('PCA 2nd strong dimension')
title('Original Labled Samples on 2 Dimensional Reduced Space')


%%
train_precent = 0.8;
N = size(X,2);
num_train_samples= floor(train_precent*N);
rand_indx = randperm(N);
X_train = X(:,rand_indx(1:num_train_samples));
y_train = y(rand_indx(1:num_train_samples));
X_test = X(:,rand_indx(num_train_samples+1:end));
y_test = y(rand_indx(num_train_samples+1:end));

%% K means
[yK ,Centers, KmeanError] = K_means(X,2);

figure()
plot(X1pca(yK==1),X2pca(yK==1),'r+')
hold on 
plot(X1pca(yK==2),X2pca(yK==2),'b+')
xlabel('PCA 1st strong dimension')
ylabel('PCA 2nd strong dimension')
title('K-Means Labled Samples on 2 Dimensional Reduced Space')


[yK ,Centers, KmeanError] = K_means(X,3);

figure()
plot(X1pca(yK==1),X2pca(yK==1),'r+')
hold on 
plot(X1pca(yK==2),X2pca(yK==2),'b+')
plot(X1pca(yK==3),X2pca(yK==3),'g+')
xlabel('PCA 1st strong dimension')
ylabel('PCA 2nd strong dimension')
title('K-Means Labled Samples on 2 Dimensional Reduced Space')

%% Supervised Binary Classification

%  tic
%  trainedStats = naiveBayesTrain(X_train, y_train);
%  toc
%  tic
%  [y_pred_test, err_test]   = naiveBayesTest(X_test, y_test, trainedStats);
%  toc
%  tic
%  [y_pred_train, err_train] = naiveBayesTest(X_train, y_train, trainedStats);
%  toc

 %% Logistic Regression
% K=10; %num of groups for training
% group_size = floor(num_train_samples/K);
% for i =1:K-1
%     mini_train_sets{i} = X_train(:,(i-1)*group_size+1:i*group_size);
%     mini_y_sets{i} = y_train((i-1)*group_size+1:i*group_size);
% end
% mini_train_sets{K} = X_train(:,i*group_size+1:end);
% mini_y_sets{K} = y_train(i*group_size+1:end);
% 
% rep =40;
% idx = [];
% for i = 1:rep
%     idx = [idx randperm(K,K)];
% end
% 
% % eta = linspace(1e-3, 5e-6, rep);
% % etaVec = linspace(0.1, 5e-9, rep);
% etaVec = 1;
% len = length(etaVec);
% 
% for i = 1:len
%     curTestSamplesCols = 1:size(mini_train_sets,2);
%     curXtrain = mini_train_sets(curTestSamplesCols ~= idx(i));
%     curYtrain = mini_y_sets(curTestSamplesCols ~= idx(i));
%     curXval = mini_train_sets(curTestSamplesCols == idx(i));
%     curYval = mini_y_sets(curTestSamplesCols == idx(i));
%     X_train_no_val = [];
%     y_train_no_val = [];
%     for j = 1:length(curXtrain)
%         X_train_no_val = [curXtrain{j} X_train_no_val];
%         y_train_no_val = [curYtrain{j}; y_train_no_val];
%     end 
%     trained_teta = logisticRegTrain(X_train_no_val,y_train_no_val, 500, etaVec(i));
%     y_predicted = logisticRegTest(curXval{1},trained_teta);
%     err(i) = 100*sum(abs(curYval{1}-y_predicted))/length(y_predicted)
% end
% 
% [~, bestEtaidx] = min(err);
% eta = etaVec(bestEtaidx);

