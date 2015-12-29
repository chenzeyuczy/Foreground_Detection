% This is a script for test.

% get_proposals(images{3});

% img = im2double(rgb2gray(img));
% img = rgb2gray(im2double(img));
% imshow(img);

% videoIndex = 6;
% images = data_info{videoIndex}.data;
% img_num = length(images);
% thld = 10;
% for index = 2:img_num
%     diff = diff_between_images(images{index}, images{index - 1}, thld);
%     imshow(diff);
%     pause()
% end

% % Choose video.
% videoIndex = 6;
% images = data_info{videoIndex}.data;
% ground_truth = data_info{videoIndex}.gt;
% imgNum = length(images);
% fg_ratio = zeros(imgNum, 1);
% 
% for index = 1:imgNum
%     gt = ground_truth{index};
%     [width, height, ~] = size(gt);
%     fg_size = sum(gt(:));
%     fg_ratio(index) = fg_size / (width * height);
%     fprintf('Foreground ratio in frame %d in video %d: %s\n', index, videoIndex, fg_ratio(index));
% end
% fprintf('Max ratio: %s; Min ratio: %s\n', max(fg_ratio), min(fg_ratio));


% Choose video.
videoIndex = 1;
images = data_info{videoIndex}.data;
imgNum = length(images);

fprintf('Video %d:\n', videoIndex);
for imgIndex = 12
    img = images{imgIndex};
    [props, boxes] = get_proposals(img);
    prop_num = length(props);
    fprintf('%d proposal(s) found in image %d.\n', prop_num, imgIndex);
    img_size = size(img(:), 1);
    for opIndex = 1:100
        prop_size = sum(sum(props{opIndex}));
        prop_ratio = 1.0 * prop_size / img_size;
        show_op(images{imgIndex}, props{opIndex}, boxes(opIndex, :));
        fprintf('Size ratio for proposal %d in image %d: %f%%\n', opIndex, imgIndex, prop_ratio * 100);
        pause(0.6);
    end
end