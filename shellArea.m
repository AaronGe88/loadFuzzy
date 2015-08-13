function [ surfaceArea ] = normal( evol, sth )
%LoadCalculate 
%   inputs: evol, sth
    areas = evol ./ sth
	surfaceArea = sum(areas)
end

