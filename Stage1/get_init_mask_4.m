% Function to get initial mask from video 4.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_4(images)    
    img_num = length(images);
    init_mask = cell(img_num, 1);
    mask = cell(img_num, 1);
%     props = cell(img_num, 1);
%     boxes = cell(img_num, 1);
    
    start_num = 8;
    max_prop_num = 100;
    max_pair_select = 6;
    
    for img_index = 1:img_num
        img = images{img_index};
%         [props{img_index}, boxes{img_index}] = get_proposals(img);
        saliency_map = get_saliency(img);
        otsu_threshold = multithresh(saliency_map);
        mask{img_index} = im2bw(saliency_map, otsu_threshold);
        if img_index <= start_num
            init_mask{img_index} = mask{img_index};
        elseif img_index > start_num
            img_index_adjacent = img_index - 1;
            img1 = images{img_index_adjacent};
            img2 = images{img_index};
            mask1 = mask{img_index_adjacent};
            mask2 = mask{img_index};
            
%             init_mask{img_index} = refine_with_adjacent_frame(img1, img2, prop1, prop2, box1, box2, mask1, mask2, max_pair_select, max_prop_num);
            init_mask{img_index} = select_proposal(img1, img2, mask1, max_prop_num, max_pair_select);
        end
    end
end
