function mask = get_init_mask(img, props, pre_mask, pre_img, max_prop_num)
    
    % Get features from provious foreground region.
    dim = 16;
    stdFeat = getMaskHist(pre_img, pre_mask, dim);
    areaThresh = sum(pre_mask(:));
    
    prop_num = size(props, 1);
    max_prop_num = min(prop_num, max_prop_num);
    
    mask = false(size(img, 1), size(img, 2));
    
    for index = 1:max_prop_num
        prop_index = index_list(index);
        prop_mask = props(prop_index, :);
        prop_mask = prop_mask > 0;
        if fitConstrain(prop_mask, pre_mask)
            mask = mask | prop_mask;
        end
    end
end

function status = fitConstrain(prop_mask, pre_mask)
    status = true;
end