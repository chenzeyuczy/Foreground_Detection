% Function to get initial mask from video 5.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_5(images)
    img_num = length(images);
    
    train_num = 7;
    learn_rate = 0.005;
    init_mask = cell(img_num, 1);
    diff_mask = cell(img_num, 1);
    
    % Get mask for image in range(0, imgIndex).
    % Start period.
	detector = vision.ForegroundDetector('NumTrainingFrames', 3, ...
        'NumGaussians', 3, 'LearningRate', learn_rate, 'InitialVariance', 30*30);
    for imgIndex = 1 : train_num + 1
        img = images{imgIndex};
        diff_mask{imgIndex} = step(detector, img);
    end
    % Stable period.
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
    % Morphology process.
    m0 = [1, 0, 1; 1, 0, 1; 1, 0, 1];
    m1 = [0, 1, 0; 1, 0, 1; 0, 1, 0];
    m2 = [0, 1, 0; 1, 1, 1; 0, 1, 0];
    for imgIndex = 1:img_num     
        diff = diff_mask{imgIndex};
        diff = imerode(diff, m0) | imerode(diff, m1);
        diff = imdilate(diff, m2);
        diff_mask{imgIndex} = diff;
    end
    
    % Choose good proposal.
    max_prop_selete = 20;
    max_prop_ratio = 0.013;
    min_diff_ratio = 0.3;
    min_mask_ratio1 = 0.005;
    min_mask_ratio2 = 0.010;
    min_mask_ratio3 = 0.015;
    for imgIndex = 1:img_num
        img = images{imgIndex};
        [height, width, ~] = size(img);
        init_mask{imgIndex} = false(height, width);
        img_size = height * width;
        [props, boxes] = get_proposals(img);
        
        for propIndex = 1:max_prop_selete
            p = props{propIndex};
            b = boxes(propIndex, :);
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
%         subplot(1, 3, 1);
%         imshow(diff_mask{imgIndex});
        mask_ratio = sum(sum(init_mask{imgIndex})) / img_size;
%         fprintf('Mask ratio for image %d: %f\n', imgIndex, mask_ratio);
%         subplot(1, 3, 2);
%         imshow(init_mask{imgIndex});
        if mask_ratio < min_mask_ratio1
            init_mask{imgIndex} = fill_fg_with_prop(init_mask{imgIndex}, props, 4);
        elseif mask_ratio < min_mask_ratio2
            init_mask{imgIndex} = fill_fg_with_prop(init_mask{imgIndex}, props, 3);
        elseif mask_ratio < min_mask_ratio3
            init_mask{imgIndex} = fill_fg_with_prop(init_mask{imgIndex}, props, 2);
        end
%         subplot(1, 3, 3);
%         imshow(init_mask{imgIndex});
%         set(gcf, 'name', ['Image ' num2str(imgIndex)], 'numbertitle', 'off');
%         pause(0.1);
    end
end