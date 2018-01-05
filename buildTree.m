function [node] = buildTree(S, yS, benchmark)
d = size(S,1);
N = size(S,2);
if (d == 1 | size(unique(yS))==1)
    isTag1 = sum(yS)> sum(1-yS);
    node.tag = (isTag1 == 1);
    return
end
node = buildNode(S,yS,benchmark);
Sleft = node.leftX;
Sleft(node.d,:) = [];
Sright = node.rightX;
Sright(node.d,:) = [];
display('entering right buildTree')
node.leftNode = buildTree(Sleft, node.leftY, benchmark);
display('entering left buildTree')
node.rightNode = buildTree(Sright, node.rightY, benchmark);
end



function [node] = buildNode(S, yS, benchmark)
d = size(S,1);
N = size(S,2);

for j = 1:d
    %t{j} = findT(S(j,:), yS)
    singleFeature = S(j,:);
    featureOptionsT = findT(singleFeature, yS);
    for i =1:length(featureOptionsT)
       SM1 = singleFeature(singleFeature>featureOptionsT(i));
       ym1 = yS(singleFeature>featureOptionsT(i));
       SM2 = singleFeature(singleFeature<=featureOptionsT(i));
       ym2 = yS(singleFeature<=featureOptionsT(i));
       p1  = sum(ym1)/length(SM1);
       p2  = sum(ym2)/length(SM2);
       Qt(i) = (length(SM1)/N)*calcBench(p1,benchmark) + (length(SM2)/N)*calcBench(p2,benchmark);
    end
    [qMaxPerFeature(j), idx] = max(Qt);
    tMaxPerFeature(j) = featureOptionsT(idx);  
end
    [~, dimIdx] = max(qMaxPerFeature);
    t = tMaxPerFeature(dimIdx);
    chosenDim = S(dimIdx,:);
    leftIdx = find(chosenDim<t);
    rightIdx =  find(chosenDim>=t);
    node.t = t;
    node.d= dimIdx;
    node.leftX  = S(:,leftIdx); 
    node.leftY  = yS(leftIdx);
    node.rightX = S(:,rightIdx);  
    node.rightY = yS(rightIdx);
end

function [Q] = calcBench(p,benchmark)
p = [p, 1-p];
    switch benchmark
            case 'classErr'
                Q = 1-max(p);
            case 'Gini'
                Q = sum(p.*(1-p));
            case 'Antropy'
                Q = sum(-p.*log2(p));
    end
end

function [t] = findT(S, yS)
gSize1 = sum(yS);
gSize0 = length(yS) - gSize1;

smallGroupTag = (gSize1<gSize0);
%--- find the Ti----%
Ssmall = S(yS == smallGroupTag);
Sbig   = S(yS ~= smallGroupTag);

for i=1:length(Ssmall)
    [~, idx] = min(abs(Ssmall(i)-Sbig));
    t(i) = (Ssmall(i)+Sbig(idx(1)))/2;
end

end
% 
% function [t] = findT(S, yS)
% gSize1 = sum(yS);
% gSize0 = length(yS) - gSize1;
% 
% smallGroupTag = (gSize1<gSize0);
% %--- find the Ti----%
% Ssmall = S(yS == smallGroupTag);
% Sbig   = S(yS ~= smallGroupTag);
% 
% t = linspace(min(S)+0.001,max(S)-0.001,100);
% 
% end
