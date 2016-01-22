% Function to get initial mask from video 2.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_2(images)
    img_num = length(images);
    
    train_num = 2;
    learn_rate = 0.02;
    diff_mask = cell(img_num, 1);
    % Get mask for image in range(0, imgIndex).
	detector = vision.ForegroundDetector('NumTrainingFrames', train_num, ...
        'NumGaussians', 3, 'LearningRate', learn_rate, 'InitialVariance', 30*30);
    for img_index = 1 : train_num + 1
        img = images{img_index};
        diff_mask{img_index} = step(detector, img);
    end
    
    detector = vision.ForegroundDetector('NumTrainingFrames', train_num ,...
            'NumGaussians', 5, 'LearningRate', 0.005, 'InitialVariance', 30*30);
    for img_index = train_num + 2: img_num
        img = images{img_index};
        for temIndex = img_index - train_num - 1: img_index - 1
            fg_tmp = step(detector, images{temIndex});
        end
        diff_mask{img_index} = step(detector, img);
        reset(detector);
    end
    
    max_prop_selete = 30;
    max_prop_ratio = 0.013;
    min_diff_ratio = 0.25;
    init_mask = cell(img_num, 1);
    for img_index = 1:img_num
        img = images{img_index};
        [height, width, ~] = size(img);
        init_mask{img_index} = false(height, width);
        img_size = height * width;
        [props, boxes] = get_proposals(img);
        
        for propIndex = 1:max_prop_selete
            p = props{propIndex};
%             b = boxes(propIndex, :);
            prop_size = sum(p(:));
            if prop_size / img_size > max_prop_ratio
                continue
            end
            diff_ratio = sum(sum(diff_mask{img_index} & props{propIndex})) / prop_size;
            if diff_ratio < min_diff_ratio
                continue
            end
            init_mask{img_index} = init_mask{img_index} | p;
        end
        init_mask{img_index} = fill_fg_with_prop(init_mask{img_index}, props, 1);
    end
end