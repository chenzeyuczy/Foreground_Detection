% Function to extract histogram feathers from an image.
% Input
%     - img: Original image.
%     - mask: Mask for proposal with the same size as image.
%     - dim: Number of bins in histogram.
% Output
%     - feat: Histogram features extracted from an image.
% Writen by chenzy.

function feat = get_mask_hist(img, mask, dim)
    % Parameter initialization.
    if nargin < 3
        dim = 16;
    end
    
    % Get pixels within mask in 3 channels.
    mask = logical(mask);
    ch1 = img(:,:,1);
    ch2 = img(:,:,2);
    ch3 = img(:,:,3);
    px1 = ch1(mask);
    px2 = ch2(mask);
    px3 = ch3(mask);
    
    % Calculate histogram.
    hist1 = hist(double(px1), dim);
    hist2 = hist(double(px2), dim);
    hist3 = hist(double(px3), dim);
    
    feat = [hist1; hist2; hist3];
end