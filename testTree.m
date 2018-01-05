function [tag] = testTree(tree, X)
%BUILDTREE Summary of this function goes here
%   Detailed explanation goes here
if (isfield(tree, 'tag'))
    tag = tree.tag;
    return
else
    right = X(tree.d)>tree.t;
    X(tree.d) =[]; 
    if(right) 
        tag = testTree(tree.rightNode, X);
    else
        tag = testTree(tree.leftNode, X);
    end
end
end

