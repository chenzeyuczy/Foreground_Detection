% Function to get initial mask from video 3.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_3(images)    
    img_num = length(images);
    init_mask = cell(img_num, 1);
    train_num = 3;
    for img_index = 1:img_num
        img = images{img_index};
        saliency_map = get_saliency(img);
        otsu_threshold = multithresh(saliency_map);
        init_mask{img_index} = im2bw(saliency_map, otsu_threshold);
        
        if img_index >= train_num
            % Do something.
            if img_index > 1
                img1 = images{img_index - 1};
            else
                img1 = images{img_index + 1};
            end
            img2 = images{img_index};
            [props, boxes] = get_proposals(img);
            init_mask{img_index} = select_proposal(img1, img2, init_mask{img_index}, 10);
        end
    end
end