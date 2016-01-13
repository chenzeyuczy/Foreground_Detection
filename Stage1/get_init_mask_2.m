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
    for imgIndex = 1 : train_num + 1
        img = images{imgIndex};
        diff_mask{imgIndex} = step(detector, img);
    end
    
    detector = vision.ForegroundDetector('NumTrainingFrames', train_num ,...
            'NumGaussians', 5, 'LearningRate', 0.005, 'InitialVariance', 30*30);
    for imgIndex = train_num + 2: img_num
        img = images{imgIndex};
        for temIndex = imgIndex - train_num - 1: imgIndex - 1
            fg_tmp = step(detector, images{temIndex});
        end
        diff_mask{imgIndex} = step(detector, img);
        reset(detector);
    end
    
    max_prop_selete = 30;
    max_prop_ratio = 0.013;
    min_diff_ratio = 0.25;
    init_mask = cell(img_num, 1);
    for imgIndex = 1:img_num
        img = images{imgIndex};
        [height, width, ~] = size(img);
        init_mask{imgIndex} = false(height, width);
        img_size = height * width;
        [props, boxes] = get_proposals(img);
        
        for propIndex = 1:max_prop_selete
            p = props{propIndex};
%             b = boxes(propIndex, :);
            prop_size = sum(p(:));
            if prop_size / img_size > max_prop_ratio
                continue
            end
            diff_ratio = sum(sum(diff_mask{imgIndex} & props{propIndex})) / prop_size;
            if diff_ratio < min_diff_ratio
                continue
            end
            init_mask{imgIndex} = init_mask{imgIndex} | p;
        end
        init_mask{imgIndex} = fill_fg_with_prop(init_mask{imgIndex}, props, 1);
%         imshow(init_mask{imgIndex});
%         title(num2str(imgIndex));
%         pause(0.1);
    end
end