function [ yAxial ] = mxDistance( slide )
%LoadCalculate 
%   inputs: slide

    y = slide(:,2);
    yAxial = mean(y);
end

