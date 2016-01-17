% Function to get features of superpixels.
% Input
%	superpixel: Map of superpixels in a image.
%	image: Original image.
% Output
%	sp_feature: Features of superpixels.
% Writen by chenzy.

function sp_feature = get_sp_feature(superpixel, image)
	sp_num = max(superpixel(:));
	[height, width, dim] = size(image);
	sp_feature = zeros(sp_num, dim);

	lab_img = rgb2lab(image);
	for sp_index = 1:sp_num
		sp_pos = find(superpixel == sp_index);
		lab_img = reshape(lab_img, [height * width, dim]);
		sp_feature(sp_index, :) = mean(lab_img(sp_pos,:));
	end
end