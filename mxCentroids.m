function [ centers ] = mxCentroids( coordMat, massMat )
%LoadCalculate 
%   inputs: slide
	x = coordMat(:,1);
	y = coordMat(:,2);
	z = coordMat(:,3);

	ms = [coordMat, massMat'];
	mass = sortrows(ms,2);
	[r, c] = size(mass);
	low = 0;
	up = r;

	for ii = 1 : r
		node = mass(ii, :);
		if node(2) > -160
			low = ii;
			break;
		end;
	end;
	for ii = r : -1 : 1
		node = mass(ii,:);
		if node(2) < 20
			up = ii;
			break;
		end;
	end;

	mass = mass(low:up,:);	
	mxup = mass(:,1) .* mass(:,4);
	myup = mass(:,2) .* mass(:,4);
	mzup = mass(:,3) .* mass(:,4);
	
	mxup = sum(mxup);
	myup = sum(myup);
	mzup = sum(mzup);
	
	sxup = sum(mass(:,1));
	syup = sum(mass(:,2));
	szup = sum(mass(:,3));
	mss = sum(mass(:,4));
	[sm,~] = size(mass(:,4));
	massCentroid = [mxup, myup, mzup] / mss;
	shapeCentroid = [sxup, syup, szup] / sm;
	centers =[massCentroid; shapeCentroid];
end

