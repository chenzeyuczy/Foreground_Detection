% Function to get initial mask from video 1.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_1(images)
    img_num = length(images);
    init_mask = cell(img_num, 1);
    m0 = [1, 0, 1; 0, 0, 0; 1, 0, 1];
    m1 = [0, 1, 0; 1, 0, 1; 0, 1, 0];
    m2 = [0, 1, 0; 1, 1, 1; 0, 1, 0];
    for img_index = 1:img_num
        img = images{img_index};
        if img_index == 1
            img2 = images{img_index + 1};
        else
            img2 = images{img_index - 1};
        end
        thld = 0.99;
        diff = diff_between_images(img, img2, thld);
        diff = imerode(diff, m0) | imerode(diff, m1);
        
       [height, width, depth] = size(img);
       mask = diff;
        [props, boxes] = get_proposals(img);
        prop_num = length(props);
        max_prop_ratio = 0.008;
        min_overlap_ratio = 0.4;
        for prop_index = 1:prop_num
            p = props{prop_index};
            b = boxes(prop_index,:);
            if sum(p(:)) / (height * width) > max_prop_ratio
                continue
            end
            overlap_region = p & diff;
            overlap_ratio = sum(overlap_region(:)) / sum(p(:));
            if overlap_ratio >= min_overlap_ratio
                mask = mask | p;
            end
        end
        mask = imerode(mask, m0) | imerode(mask, m1);

        init_mask{img_index} = mask;
    end
end
