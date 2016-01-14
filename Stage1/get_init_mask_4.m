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
    
    for imgIndex = 1:img_num
        if imgIndex <= start_num
            img = images{imgIndex};
            saliency_map = get_saliency(img);
            otsu_threshold = multithresh(saliency_map);
            init_mask{imgIndex} = im2bw(saliency_map, otsu_threshold);
        elseif imgIndex > start_num
            img1 = images{imgIndex - 1};
            img2 = images{imgIndex};
            init_mask{imgIndex} = select_proposal(img1, img2, init_mask{imgIndex - 1}, max_prop_num, max_pair_select);
        end
    end
end
