function [ thinmost ] = mxThinnmost( eles, labels )
%LoadCalculate 
%   inputs: slide
	elements = [eles;labels];
	elements = elements';
	%thin = sortrows(elements,1);
	[thin, index] = min(elements(:,1));
    thinmost = [thin, elements(index,2)];
end