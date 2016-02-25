% Function to refine initial mask with info from adjacent frame.
% Input
%   img1: Current image.
%   img2: Adjacent image.
%   prop1: Proposals of current iamge.
%   prop2: Proposals of adjacent image.
%   box1: Boxes of current iamge.
%   box2: Boxes of adjacent image.
%   mask1: Mask of current image.
%   mask2: Mask of adjacent image.
%   max_pair_select: Maximum number of pairs to choose.
% Output
%   mask: Refined mask of current image.
% Writen by chenzy.

function mask = refine_with_adjacent_frame(img1, img2, prop1, prop2, box1, box2, mask1, mask2, max_pair_num, max_prop_num)
    if nargin < 10
        max_prop_num = 100;
    end
    
    mask = mask1 & mask2;
    
    % Convert to diverse color space.
    labImg1 = rgb2lab(img1);
    ycbcrImg1 = rgb2ycbcr(img1);
    hsvImg1 = rgb2hsv(img1);
    labImg2 = rgb2lab(img2);
    ycbcrImg2 = rgb2ycbcr(img2);
    hsvImg2 = rgb2hsv(img2);
    
    % Filterate proposals.
    prop1 = filterate_prop(prop1, mask1, mask2);
    prop2 = filterate_prop(prop2, mask1, mask2);
    
    % Preallocate memory space.
    prop_num1 = min(length(prop1), max_prop_num);
    prop_num2 = min(length(prop2), max_prop_num);
    prop_dist = zeros(prop_num1, prop_num2);
    size_sim = zeros(prop_num1, prop_num2);
    shape_sim = zeros(prop_num1, prop_num2);

    lastHist = cell(prop_num1, 1);
    size1 = zeros(prop_num1, 1);
    thisHist = cell(prop_num2, 1);
    size2 = zeros(prop_num2, 1);

    % Calculate features for proposals in both images.
    for index = 1:prop_num1
        prop = prop1{index};
        rgbHist = get_mask_hist(img1, prop);
        labHist = get_mask_hist(labImg1, prop);
        ycbcrHist = get_mask_hist(ycbcrImg1, prop);
        hsvHist = get_mask_hist(hsvImg1, prop);
        lastHist{index} = merge_hist_info(rgbHist, labHist, ycbcrHist, hsvHist);
        size1(index) = sum(prop(:));
    end
    for index = 1:prop_num2
        prop = prop2{index};
        rgbHist = get_mask_hist(img2, prop);
        labHist = get_mask_hist(labImg2, prop);
        ycbcrHist = get_mask_hist(ycbcrImg2, prop);
        hsvHist = get_mask_hist(hsvImg2, prop);
        thisHist{index} = merge_hist_info(rgbHist, labHist, ycbcrHist, hsvHist);
        size1(index) = sum(prop(:));
    end
    width1 = box1(:,3) - box1(:,1);
    height1 = box1(:,4) - box1(:,2);
    width2 = box2(:,3) - box2(:,1);
    height2 = box2(:,4) - box2(:,2);
    
    for index1 = 1:prop_num1
        for index2 = 1:prop_num2
            prop_dist(index1, index2) = 0.5 * (sum((thisHist{index2} - lastHist{index1}) .^ 2 ./ (thisHist{index2} + lastHist{index1} + eps)));
            size_sim(index1, index2) = abs(size1(index1) - size2(index2)) / max(size1(index1), size2(index2));
            shape_sim(index1, index2) = abs((width1(index1) - width2(index2)) * (height1(index1) - height2(index2))) / (eps + abs(width1(index1) * height1(index1) - width2(index2) * height2(index2)));
        end
    end
    
    rank_dist = 1 * prop_dist + 1 * size_sim + 1 * shape_sim;
    [~, disIdx] = sort(rank_dist(:));
    rowIdx = mod(disIdx - 1, size(rank_dist, 1)) + 1;
    colIdx = ceil(disIdx / size(rank_dist, 1));
    matchedIndex = [rowIdx(:), colIdx(:)];
    
    % Add good proposals into mask.
    for index = 1:max_pair_num
        prop = prop1{matchedIndex(index, 1)};
        mask = mask | prop;
    end
end

% Choose proposals with mask whose overlap ratio is larger than theshold
% while not exceed maximum size ratio.
function result = filterate_prop(props, mask1, mask2, min_overlap, max_size_ratio)
    if nargin < 4
        min_overlap = 0.6;
    end
    if nargin < 5
        max_size_ratio = 0.05;
    end
    
    [height, width] = size(mask1);
    counter = 0;
    prop_num = length(props);
    img_size = height * width;
    
    for prop_index = 1:prop_num
        prop = props{prop_index};
        prop_size = sum(prop(:));
        if prop_size / img_size > max_size_ratio
            continue
        end
        overlap1 = sum(sum(prop & mask1)) / prop_size;
        overlap2 = sum(sum(prop & mask2)) / prop_size;
        if overlap1 >= min_overlap || overlap2 >= min_overlap
            counter = counter + 1;
            result{counter} = prop;
        end
    end
end
