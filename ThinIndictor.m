function [ indictor ] = ThinIndictor( thin, flsd )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    thinIndictor = newfis('thinIndictor');
    
    thinIndictor = addvar(thinIndictor, 'input', 'thin',[-0.1, 0]);
    thinIndictor = addmf(thinIndictor, 'input', 1, 'critical', 'gaussmf', [0.01699, -0.1]);
    thinIndictor = addmf(thinIndictor, 'input', 1, 'show', 'gaussmf', [0.01699, -0.05]);
    thinIndictor = addmf(thinIndictor, 'input', 1, 'remain', 'gaussmf',  [0.01699, 0]);
    %plotmf(thinIndictor, 'input', 1);
    
    thinIndictor = addvar(thinIndictor, 'input', 'flsd',[0, 1.0]);
    thinIndictor = addmf(thinIndictor, 'input', 2, 'far', 'gaussmf', [0.1699, 0]);
    thinIndictor = addmf(thinIndictor, 'input', 2, 'middle displacement', 'gaussmf', [0.1699, 0.4]);
    thinIndictor = addmf(thinIndictor, 'input', 2, 'close', 'gaussmf',  [0.1699, 0.7]);
    %plotmf(thinIndictor, 'input', 2);
    
    thinIndictor = addvar(thinIndictor, 'output', 'indictor',[0, 1.0]);
    thinIndictor = addmf(thinIndictor, 'output', 1, 'small', 'gaussmf', [0.1699, 0]);
    thinIndictor = addmf(thinIndictor, 'output', 1, 'normal', 'gaussmf', [0.1699, 0.5]);
    thinIndictor = addmf(thinIndictor, 'output', 1, 'large', 'gaussmf',  [0.1699, 1]);
    thinRule = [1,1,2,1,1;1,2,3,1,1;1,3,3,1,1,;2,1,1,1,1;2,2,2,1,1;2,3,3,1,1;3,1,1,1,1;3,2,2,1,1;3,3,3,1,1];
    thinIndictor = addrule(thinIndictor,thinRule);
    %gensurf(thinIndictor);
    in = [thin,flsd];
    indictor = evalfis(in,thinIndictor);
end

