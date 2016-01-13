% Function to get initial mask from video 3.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_3(images)    
    img_num = length(images);
    init_mask = cell(img_num, 1);
    for imgIndex = 1:img_num
        img = images{imgIndex};
        saliency_map = get_saliency(img);
        otsu_threshold = multithresh(saliency_map);
        init_mask{imgIndex} = im2bw(saliency_map, otsu_threshold);
    end
end