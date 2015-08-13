function [ surfaceArea ] = mxShellArea( evol, sth )
%LoadCalculate 
%   inputs: evol, sth
    areas = evol ./ sth
	surfaceArea = sum(areas)
	surfaceArea = surfaceArea(1)
end

