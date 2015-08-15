function [ centers ] = mxCentroids( coordMat, massMat )
%LoadCalculate 
%   inputs: slide
	x = coordMat(:,1);
	y = coordMat(:,2);
	z = coordMat(:,3);
	
	mxup = x .* massMat';
	myup = y .* massMat';
	mzup = z .* massMat';
	
	mxup = sum(mxup);
	myup = sum(myup);
	mzup = sum(mzup);
	
	sxup = sum(x);
	syup = sum(y);
	szup = sum(z);
	mass = sum(massMat);
	[~,sm] = size(massMat);
	massCentroid = [mxup, myup, mzup] / mass;
	shapeCentroid = [sxup, syup, szup] / sm;
	centers =[massCentroid; shapeCentroid];
end

