% Function to get initial mask from video 4.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_4(images)
    % Parameters initialization.
    opts.slic_regionsize = 20;
    opts.slic_regularizer = 0.1;
    opts.show_sp_map = 0;
    
    img_num = length(images);
    init_mask = cell(img_num, 1);
    for imgIndex = 1:img_num
        img = images{imgIndex};
        saliency_map = manifold_ranking2(img, opts);
        otsu_threshold = multithresh(saliency_map);
        init_mask{imgIndex} = im2bw(saliency_map, otsu_threshold);
    end
end