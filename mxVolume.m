function volume  = mxVolume( slideArea, pos, normals )
%LoadCalculate 
%   inputs: slide
    [~, n] = size(slideArea);
    vs = zeros(n-1);
	for ii = 1 : n - 1
        up = normals(ii) .* normals(ii+1);
        down = sqrt(dot(normals(ii), normals(ii))*dot(normals(ii+1),normals(ii+1)));
        angleSin = sin(up /down);
        vs(ii) = (slideArea(ii) + slideArea(ii + 1)) * (pos(ii+1) - pos(ii)) / 2 * angleSin;
    end
    volume = sum(vs);
    volume = volume(1);
end