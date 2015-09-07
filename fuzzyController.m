function [ dR ] = fuzzyController(feathers)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
	dW = feathers(1);
	dT = feathers(2);
	displacement = -feathers(3);
	flsd = feathers(4);
	feedlow = 2.7;
	feedup = 4.4;
	pressup = 0.35;
	presslow = 0;
	thDw = 0.27;
	thDt = 0.05;
	thDisp = 0.1;
	% if flsd > 0.4
		% feed = 6;
		% press = 0.5;
		% thDw = 0.2;
		% thDt = 0.1;
		% thDisp = 0.2
	% end
	alphaDw = 0.1699 * 0.015;
	alphaDt = 0.1699 * thDt;
    dPressure = newfis('pressure');
    dPressure = addvar(dPressure,'input','wrinkle',[0.249,0.269]);
    dPressure = addmf(dPressure,'input',1,'decrease','gaussmf', [alphaDw, 0.249]);
    dPressure = addmf(dPressure,'input',1,'remain','gaussmf', [alphaDw, 0.2595]);
    dPressure = addmf(dPressure,'input',1,'increase','gaussmf', [alphaDw, 0.269]); 
    
    dPressure = addvar(dPressure, 'input', 'thickness',[-0.1, 0]);
    dPressure = addmf(dPressure, 'input', 2, 'decrease', 'gaussmf', [0.01699, -0.1]);
    dPressure = addmf(dPressure, 'input', 2, 'remain', 'gaussmf', [0.01699, -0.05]);
    dPressure = addmf(dPressure, 'input', 2, 'increase', 'gaussmf',  [0.01699, 0]);
    
	alphaPre = 0.1699 * (pressup -presslow);
    dPressure = addvar(dPressure, 'output' ,'Pressure',[presslow, pressup]);
    dPressure = addmf(dPressure, 'output', 1,'decrease','gaussmf', [alphaPre, presslow]);
    dPressure = addmf(dPressure,'output',1,'remain','gaussmf', [alphaPre, (presslow +pressup) /2 ]);
    dPressure = addmf(dPressure, 'output',1,'increase','gaussmf', [alphaPre, pressup]);
    dPRules = [1,1,1,1,1;1,2,1,1,1;1,3,1,1,1,;2,1,2,1,1;2,2,2,1,1;2,3,1,1,1;3,1,3,1,1;3,2,2,1,1;3,3,1,1,1];
    dPressure = addrule(dPressure,dPRules);
    
    in = [dW, dT];
    dp = evalfis(in,dPressure); 
    
    dFeed = newfis('axialFeed');
    dFeed = addvar(dFeed,'input','wrinkle',[0.249,0.269]);
    dFeed = addmf(dFeed,'input',1,'decrease','gaussmf', [alphaDw, 0.249]);
    dFeed = addmf(dFeed,'input',1,'remain','gaussmf', [alphaDw, 0.2595]);
    dFeed = addmf(dFeed,'input',1,'increase','gaussmf', [alphaDw, 0.269]); 
    
    dFeed = addvar(dFeed, 'input', 'thickness',[-0.1, 0]);
    dFeed = addmf(dFeed, 'input', 2, 'decrease', 'gaussmf', [0.01699, -0.1]);
    dFeed = addmf(dFeed, 'input', 2, 'remain', 'gaussmf', [0.01699, 0.05]);
    dFeed = addmf(dFeed, 'input', 2, 'increase', 'gaussmf',  [0.01699, 0.0]);
    
    dFeed = addvar(dFeed, 'output' ,'Pressure',[feedlow, feedup]);
	
	alpha = 0.1699 * (feedup - feedlow);
    dFeed = addmf(dFeed, 'output', 1,'decrease','gaussmf', [alpha, feedlow]);
    dFeed = addmf(dFeed,'output',1,'remain','gaussmf',  [alpha, (feedup+feedlow)/2]);
    dFeed = addmf(dFeed, 'output',1,'increase','gaussmf',  [alpha, feedup]);
    dFRules = [1,1,3,1,1;1,2,3,1,1;1,3,3,1,1;2,1,2,1,1;2,2,2,1,1;2,3,2,1,1;3,1,1,1,1;3,2,1,1,1;3,3,1,1,1];
    dFeed = addrule(dFeed,dFRules);
    df = evalfis(in,dFeed); 
    
    
    dRatio = newfis('Feed Raito');
    dRatio = addvar(dRatio,'input','centroids displacment',[0, 0.1]);
    dRatio = addmf(dRatio,'input',1,'near','gaussmf',   [0.01699, 0]);
    dRatio = addmf(dRatio,'input',1,'around','gaussmf',   [0.01699 0.05]);
    dRatio = addmf(dRatio,'input',1,'far','gaussmf',   [0.01699 0.1]);
    
    dRatio = addvar(dRatio, 'output' ,'feed ratio',[2.5,3]);
    dRatio = addmf(dRatio, 'output', 1,'small','gaussmf', [0.08493, 2.5]);
    dRatio = addmf(dRatio, 'output', 1,'middle','gaussmf', [0.08493, 2.75]);
    dRatio = addmf(dRatio, 'output', 1,'large','gaussmf', [0.08493, 3]);
    dRRule = [1,1,1,1;2,2,1,1;3,3,1,1];
    dRatio = addrule(dRatio, dRRule);
    dr = evalfis(displacement,dRatio);
    dR = [dp, df, dr];
end

