function [ dp, af, ratio ] = fuzzyController( dW, dT, cd, fld )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    fisMat = newfis('loadpath');
    fisMat = addvar(fisMat,'input','wrinkle',[-0.02,0.02]);
    fisMat = addmf(fisMat,'input',1,'decrease','gaussmf', [0.006795, -0.02]);
    fisMat = addmf(fisMat,'input',1,'remain','gaussmf', [0.006795, 0]);
    fisMat = addmf(fisMat,'input',1,'increase','gaussmf', [0.006795, 0.02]); 
    %plotmf(fisMat,'input',1);
    
    fisMat = addvar(fisMat, 'input', 'thickness',[-0.05, 0.05]);
    fisMat = addmf(fisMat, 'input', 2, 'decrease', 'gaussmf', [0.01699, -0.05]);
    fisMat = addmf(fisMat, 'input', 2, 'remain', 'gaussmf', [0.01699, 0]);
    fisMat = addmf(fisMat, 'input', 2, 'increase', 'gaussmf',  [0.01699, 0.05]);
    plotmf(fisMat, 'input', 2);

end

