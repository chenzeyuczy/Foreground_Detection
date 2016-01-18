% Function to calculate scores of superpixels inside an image,
%	according to its coverage of mask.
% Input
%	superpixel: Superpixels of an image.
%	mask: Mask to be compared with.
% Output
%	score: Scores of spuerpixels.
% Writen by chenzy.

function sp_score = score_superpixel(superpixel, mask)
	sp_num = max(superpixel(:));
	sp_score = zeros(sp_num, 1);

	for sp_index = 1:sp_num
		sp_region = superpixel == sp_index;
		sp_score(sp_index) = sum(sum(sp_region & mask)) / sum(sp_region(:));
    end
    sp_score = (sp_score - min(sp_score)) / (max(sp_score) - min(sp_score));
    thld = mean(sp_score(:));
    sp_score(sp_score > thld) = 1;
    sp_score(sp_score <= thld) = 0;
end