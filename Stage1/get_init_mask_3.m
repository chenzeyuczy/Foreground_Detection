% Function to get initial mask from video 3.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_3(images)    
    img_num = length(images);
    masks = cell(img_num, 1);
    init_mask = cell(img_num, 1);
    train_num = 3;
    
    props = cell(img_num, 1);
    boxes = cell(img_num, 1);
    for img_index = 1:img_num
        img = images{img_index};
        [props{img_index}, boxes{img_index}] = get_proposals(img);
        saliency_map = get_saliency(img);
        otsu_threshold = multithresh(saliency_map);
        masks{img_index} = im2bw(saliency_map, otsu_threshold);
        
        if img_index >= train_num
            % Deal with the first frame.
            if img_index > 1
                img_index_adjacent = img_index - 1;
            else
                img_index_adjacent = img_index + 1;
            end
            img1 = images{img_index};
            img2 = images{img_index_adjacent};
            prop1 = props{img_index};
            prop2 = props{img_index_adjacent};
            box1 = boxes{img_index};
            box2 = boxes{img_index_adjacent};
            mask1 = masks{img_index};
            mask2 = masks{img_index_adjacent};
            init_mask{img_index} = refine_with_adjacent_frame(img1, img2, prop1, prop2, box1, box2, mask1, mask2, 10);
        else
            init_mask{img_index} = masks{img_index};
        end
    end
end