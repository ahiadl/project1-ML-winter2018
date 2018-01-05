close all;
clear all;
clc;
load('BreastCancerData.mat');
N = size(X,2);
d = size(X,1);
X = X - min(X,[],2);
X = X./repmat(max(X,[],2), 1, N);

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
    mini_y_train_sets{i} = y_train((i-1)*group_size+1:i*group_size);
end
mini_train_sets{K} = X_train(:,i*group_size+1:end);
mini_y_train_sets{K} = y_train(i*group_size+1:end);

benchmark = ["Antropy", "Gini", "classErr"];

%---Cross Validation----%

rep = 10;
% random the order of the groups.
% puts the validation group at first idx evey row
for i = 1:rep
    groupsIdx = randperm(K,K);
    groupsIdx(groupsIdx == i) = [];
    idx(i,:) = [i, groupsIdx];
end

for bench = 1:3
    for validItr = 1:rep
        curXtrain = [];
        curYtrain = [];
        for k = 2:10
            curXtrain = [curXtrain, mini_train_sets{idx(validItr,k)}];
            curYtrain = [curYtrain, mini_y_train_sets{idx(validItr,k)}'];
        end
        curXval = mini_train_sets{idx(validItr,1)};
        curYval = mini_y_train_sets{idx(validItr,1)}';
        tree = buildTree(curXtrain, curYtrain, benchmark(bench)) ;
        y_predicted_train = zeros(1,size(curXval,2));
        for i =1:size(curXval,2)
            y_predicted_train(i) = testTree(tree, curXval(:,i));
        end
        errTrain(bench, validItr) = 100*sum(abs(curYval-y_predicted_train))/length(curYval);
        
        display(['Done Train Set: ',num2str(validItr)]);
    end
    display(['Done Benchmark: ',benchmark(bench)]); 
end

stdBench = std(errTrain');
meanBench = mean(errTrain');

figure()
errorbar(1:3, meanBench, stdBench)
set(gca, 'XTickLabel',benchmark, 'XTick',1:3)
xlim([0 4])
xlabel('Benchmark')
ylabel('Average Error [%]');
title('Benchmarks Performance')

tree = buildTree(X_train, y_train, "Antropy") ;
for i =1:size(X_test,2)
    y_predicted_test(i) = testTree(tree, X_test(:,i));
end

errTest = 100*sum(abs(y_test-y_predicted_test'))/length(y_test);

