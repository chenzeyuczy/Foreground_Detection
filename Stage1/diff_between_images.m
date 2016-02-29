% Function to operate temporal diffence between two images.
% Input
%   - img1: The first image, in RGB format.
%   - img2: The second image, in RGB format.
%   - thld: Threshold for motion region, optional.
% Output
%   - diff: If the threshold is given, a binary map with motion region
%   denoted as 1 is return. Otherwise, difference map is returned.
% Writen by chenzy.

function diff = diff_between_images(img1, img2, thld)
    img1 = rgb2gray(im2double(img1));
    img2 = rgb2gray(im2double(img2));
    diff = abs(img2 - img1);
    diff = im2uint8(diff);
    if nargin > 2
        thld = prctile(diff(:), thld * 100);
%         fprintf('Threshold: %d\n', thld);
        diff = diff >= thld;
    end
end