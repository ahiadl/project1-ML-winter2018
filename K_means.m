function [relations, miu_vec, error] = K_means(X,K)
rows = size(X,1);
samples_x = size(X,2);
miu_vec = zeros(rows,1,K);
miu_vec(:,1,1:K) = X(:,1:K); %random x values
X_rep = repmat(X,[1 , 1 ,K]);
stop_condition = inf;
error = 0;
while stop_condition ~= 0
    last_miu_vec = miu_vec;
    miu_vec_rep = repmat(miu_vec,[1 ,samples_x ,1]);
    auclidean_ditance = reshape(sum(sqrt((miu_vec_rep - X_rep).^2),1),samples_x,K); 
    %auclidean_ditance1 = sum(sqrt((miu_vec_rep - X_rep).^2),1); 
    [~, NNidx] = min(auclidean_ditance,[],2);
    for i=1:K
        K_class_data{i} = X(:,(NNidx == i));
        miu_vec(:,:,i) = mean(K_class_data{i},2);        
    end
    stop_condition = sum(abs(miu_vec - last_miu_vec));    
end
relations = NNidx;

for i= 1:K
   group = K_class_data{i};
   miu_vec_i_rep = repmat(miu_vec(:,:,i),[1 ,size(group,2) ,1]);
   error = error +sum(sum((group - miu_vec_i_rep).^2))
end

miu_vec = reshape(miu_vec,size(miu_vec,1),K);