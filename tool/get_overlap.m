% Function to caluclate overlap ratio betweeen two images.
% Input
%   img1: Image 1.
%   img2: Image 2.
% Output
%   overlap_ratio: Overlap ratio between two adjacent images.
% Writen by chenzy.

function overlap_ratio = get_overlap(img1, img2)
%     img1 = im2bw(img1);
%     img2 = im2bw(img2);
	if ~isequal(size(img1), size(img2))
	    img2 = imresize(img2, size(img1));
	end
    overlap_ratio = sum(sum(img1 & img2)) / sum(sum(img1 | img2));
end