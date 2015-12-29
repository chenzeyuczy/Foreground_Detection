function imgs = removeBoundary(images)
    img_num = length(images);
    imgs = cell(img_num, 1);
    for index = 1:img_num
        [height, width, ~] = size(images{index});
        left_border = 5;
        right_border = 4;
        imgs{index} = images{index}(:, left_border + 1: width - right_border, :);
    end
end