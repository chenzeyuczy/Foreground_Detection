% Function to get initial mask from video 4.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_4(images)    
    img_num = length(images);
    init_mask = cell(img_num, 1);
    
    start_num = 8;
    max_prop_num = 100;
    max_pair_select = 6;
    
    for img_index = 1:img_num
        if img_index <= start_num
            img = images{img_index};
            saliency_map = get_saliency(img);
            otsu_threshold = multithresh(saliency_map);
            init_mask{img_index} = im2bw(saliency_map, otsu_threshold);
        elseif img_index > start_num
            img1 = images{img_index - 1};
            img2 = images{img_index};
            init_mask{img_index} = select_proposal(img1, img2, init_mask{img_index - 1}, max_prop_num, max_pair_select);
        end
    end
end
