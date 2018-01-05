function [teta1] = logisticRegTrain(X,y, epoch_num, eta)
    d= size(X,1);
    N= size(X,2);
    maxX = max(X,[],2);
    minX = min(X,[],2);
    teta1 = zeros(d,1);
  %  teta0 = rand(d,1);
    for epoch = 1:epoch_num
        idx = randperm(N);
        for i =1:N
            curX = (X(:,idx(i)));
            %learn only g1 since it's a binary problem
            g1 = 1/(1+exp(-teta1'*curX));
            g0 = 1-g1;
            
            if(y(i) ==1)
%                 teta_t_p_1 = teta1 + eta*(1-g1)*curX;
                v= teta1'*curX;
                gTag = exp(-v)/((1+exp(-v))^2);
                teta1 = teta1 - eta*(1-g1)*gTag*curX;
            end
            
            if(y(i)== 0)
                loss(i) = (y(i)==0)*log((y(i)==0)/g0);
            else
                loss(i) = (y(i)==1)*log((y(i)==1)/g1);
            end
            
        end
        MainLoss(epoch) = sum(loss); 
    end 
    figure(1)
    plot(MainLoss);
end

