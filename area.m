function [ area ] = area( slide )
%LoadCalculate 
%   inputs: slide
    x = slide(:, 1);
    %y = slide(:, 2);
    z = slide(:, 3);
    
    %X = [ones(length(x),1) x z];
    %���Ϊ b = [b(1) b(2) b(3)] ��ʾ y = b(1) + b(2)*x + b(3)*z ����ϳ�����ƽ��ķ���
    %[b,~,~,~,~] = regress(y,X,95);
    %normal = [b(2), -1, b(3)];
    %slideArea = polyarea(x,z);
	[theta,r] = cart2pol(x,z);
	data = [theta r];
	pol = sortrows(data,1);
	[x,z] = pol2cart(pol(:,1),pol(:,2));
    area = polyarea(x,z);
	%slideArea = xzsorted;
    %yAxial = mean(y);
end

