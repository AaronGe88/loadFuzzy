function [ dR ] = fuzzyController(feathers)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
	dW = feathers(1);
	dT = feathers(2);
	displacement = feathers(3);
	flsd = feathers(4);
    dPressure = newfis('pressure');
    dPressure = addvar(dPressure,'input','wrinkle',[-0.02,0.02]);
    dPressure = addmf(dPressure,'input',1,'decrease','gaussmf', [0.006795, -0.02]);
    dPressure = addmf(dPressure,'input',1,'remain','gaussmf', [0.006795, 0]);
    dPressure = addmf(dPressure,'input',1,'increase','gaussmf', [0.006795, 0.02]); 
    
    dPressure = addvar(dPressure, 'input', 'thickness',[-0.05, 0.05]);
    dPressure = addmf(dPressure, 'input', 2, 'decrease', 'gaussmf', [0.01699, -0.05]);
    dPressure = addmf(dPressure, 'input', 2, 'remain', 'gaussmf', [0.01699, 0]);
    dPressure = addmf(dPressure, 'input', 2, 'increase', 'gaussmf',  [0.01699, 0.05]);
    
    dPressure = addvar(dPressure, 'output' ,'Pressure',[0, 1]);
    dPressure = addmf(dPressure, 'output', 1,'decrease','gaussmf', [0.1699, 0]);
    dPressure = addmf(dPressure,'output',1,'remain','gaussmf', [0.1699, 0.5]);
    dPressure = addmf(dPressure, 'output',1,'increase','gaussmf', [0.1699 1]);
    dPRules = [1,1,1,1,1;1,2,1,1,1;1,3,1,1,1,;2,1,2,1,1;2,2,2,1,1;2,3,1,1,1;3,1,3,1,1;3,2,2,1,1;3,3,1,1,1];
    dPressure = addrule(dPressure,dPRules);
    
    in = [dW, dT];
    dp = evalfis(in,dPressure); 
    
    dFeed = newfis('axialFeed');
    dFeed = addvar(dFeed,'input','wrinkle',[-0.02,0.02]);
    dFeed = addmf(dFeed,'input',1,'decrease','gaussmf', [0.006795, -0.02]);
    dFeed = addmf(dFeed,'input',1,'remain','gaussmf', [0.006795, 0]);
    dFeed = addmf(dFeed,'input',1,'increase','gaussmf', [0.006795, 0.02]); 
    
    dFeed = addvar(dFeed, 'input', 'thickness',[-0.05, 0.05]);
    dFeed = addmf(dFeed, 'input', 2, 'decrease', 'gaussmf', [0.01699, -0.05]);
    dFeed = addmf(dFeed, 'input', 2, 'remain', 'gaussmf', [0.01699, 0]);
    dFeed = addmf(dFeed, 'input', 2, 'increase', 'gaussmf',  [0.01699, 0.05]);
    
    dFeed = addvar(dFeed, 'output' ,'Pressure',[0,3]);
    dFeed = addmf(dFeed, 'output', 1,'decrease','gaussmf', [0.5096 0]);
    dFeed = addmf(dFeed,'output',1,'remain','gaussmf',  [0.5096 1.5]);
    dFeed = addmf(dFeed, 'output',1,'increase','gaussmf',  [0.5096 3]);
    dFRules = [1,1,3,1,1;1,2,3,1,1;1,3,3,1,1;2,1,2,1,1;2,2,2,1,1;2,3,2,1,1;3,1,1,1,1;3,2,1,1,1;3,3,1,1,1];
    dFeed = addrule(dFeed,dFRules);
    df = evalfis(in,dFeed); 
    
    
    dRatio = newfis('Feed Raito');
    dRatio = addvar(dRatio,'input','centroids displacment',[-0.1, 0]);
    dRatio = addmf(dRatio,'input',1,'far','gaussmf',   [0.01699, -0.1]);
    dRatio = addmf(dRatio,'input',1,'around','gaussmf',   [0.01699 -0.05]);
    dRatio = addmf(dRatio,'input',1,'near','gaussmf',   [0.01699 0]);
    
    dRatio = addvar(dRatio, 'output' ,'feed ratio',[2.5,3]);
    dRatio = addmf(dRatio, 'output', 1,'small','gaussmf', [0.08493, 2.5]);
    dRatio = addmf(dRatio, 'output', 1,'middle','gaussmf', [0.08493, 2.75]);
    dRatio = addmf(dRatio, 'output', 1,'large','gaussmf', [0.08493, 3]);
    dRRule = [1,1,1,1;2,2,1,1;3,3,1,1];
    dRatio = addrule(dRatio, dRRule);
    dr = evalfis(displacement,dRatio);
    dR = [dp, df, dr];
end

