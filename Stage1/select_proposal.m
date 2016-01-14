% Function to match proposals within adjacent images, only operates upon
% top K proposals in each image.
% Input
%   - img1: Image one.
%   - img2: Image two.
%   - mask: Mask to filterate proposals.
%   - max_prop_num: Maximum of proposals seleceted, whose default value is 100.
%   - pair_select_num: Number of pairs of matched proposals to be returned,
%   whose default value is the same as max_prop_num..
% Output
%   - prop_mask: Mask with selected proposals.
% Writen by chenzy.

function prop_mask = select_proposal(img1, img2, mask, max_prop_num, pair_select_num)
    % Set up default parameter.
    if nargin < 4
        max_prop_num = 100;
    end
    if nargin < 5
        pair_select_num = max_prop_num;
    end
    
    % Convert to diverse color space.
    tic();
    labImg1 = rgb2lab(img1);
    ycbcrImg1 = rgb2ycbcr(img1);
    hsvImg1 = rgb2hsv(img1);
    t = toc();
    fprintf('Convert image format in %f s.\n', t);
    tic();
    labImg2 = rgb2lab(img2);
    ycbcrImg2 = rgb2ycbcr(img2);
    hsvImg2 = rgb2hsv(img2);
    t = toc();
    fprintf('Convert image format in %f s.\n', t);
    
    % Get proposals from image.
    tic();
    [prop1, box1] = get_proposals(img1);
    min_overlap = 0.8;
    prop1 = filter_prop_with_mask(mask, prop1, min_overlap);
    t1 = toc();
    fprintf('%d proposal(s) found in %f s.\n', length(prop1), t1);
    tic();
    [prop2, box2] = get_proposals(img2);
    t2 = toc();
    fprintf('%d proposal(s) found in %f s.\n', length(prop2), t2);
    
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
    tic();
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
    t = toc();
    fprintf('Calculate features for %d proposals in img1 and %d proposals in img2 in %s s.\n', prop_num1, prop_num2, t);

    tic();
    for index1 = 1:prop_num1
        for index2 = 1:prop_num2
            prop_dist(index1, index2) = 0.5 * (sum((thisHist{index2} - lastHist{index1}) .^ 2 ./ (thisHist{index2} + lastHist{index1} + eps)));
            size_sim(index1, index2) = abs(size1(index1) - size2(index2)) / max(size1(index1), size2(index2));
            shape_sim(index1, index2) = abs((width1(index1) - width2(index2)) * (height1(index1) - height2(index2))) / (eps + abs(width1(index1) * height1(index1) - width2(index2) * height2(index2)));
        end
    end
    t = toc();
    fprintf('Calculate %d * %d distance in %f s.\n', prop_num1, prop_num2, t);

    rank_dist = 1 * prop_dist + 1 * size_sim + 1 * shape_sim;
    [~, disIdx] = sort(rank_dist(:));
    rowIdx = mod(disIdx - 1, size(rank_dist, 2)) + 1;
    colIdx = ceil(disIdx / size(rank_dist, 1));
    matchedIndex = [rowIdx(:), colIdx(:)];
    matchedIndex = matchedIndex(1:pair_select_num, :);
    
    prop_mask = false(size(mask));
    for mask_index = 1:pair_select_num
        prop = prop2{matchedIndex(mask_index, 1)};
        prop_mask = prop_mask | prop;
    end
end

% Filter proposals with mask whose overlap ratio is larger than theshold.
function result = filter_prop_with_mask(mask, props, min_overlap)
    counter = 0;
    prop_num = length(props);
    mask_size = sum(mask(:));
    
    for prop_index = 1:prop_num
        prop = props{prop_index};
        overlap = sum(prop(:)) / mask_size;
        if overlap >= min_overlap
            counter = counter + 1;
            result{counter} = prop;
        end
    end
end
            
