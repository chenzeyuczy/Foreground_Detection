% Function to get initial mask from video 1.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_1(images)
%     img_num = length(images);
%     init_mask = cell(img_num, 1);
%     for imgIndex = 1:img_num
%         img1 = images{imgIndex};
%         if imgIndex == 1
%             img2 = images{imgIndex + 1};
%         else
%             img2 = images{imgIndex - 1};
%         end
%         thld = 0.985;
%         diff = diff_between_images(img1, img2, thld);
%         m0 = [1, 0, 1; 0, 0, 0; 1, 0, 1];
%         m1 = [0, 1, 0; 1, 0, 1; 0, 1, 0];
%         m2 = [0, 1, 0; 1, 1, 1; 0, 1, 0];
%         diff = imerode(diff, m0) | imerode(diff, m1);
%         diff = imdilate(diff, m2);
%         init_mask{imgIndex} = diff;
%     end
    img_num = length(images);
    init_mask = cell(img_num, 1);
    diff_mask = cell(img_num, 1);
    
    train_num = 3;
    learn_rate = 0.005;
    
    % Get mask for image in range(0, imgIndex).
    % Start period.
	detector = vision.ForegroundDetector('NumTrainingFrames', 2, ...
        'NumGaussians', 3, 'LearningRate', learn_rate, 'InitialVariance', 30*30);
    for imgIndex = 1 : train_num + 1
        img = images{imgIndex};
        diff_mask{imgIndex} = step(detector, img);
    end
    % Stable period.
    detector = vision.ForegroundDetector('NumTrainingFrames', train_num ,...
            'NumGaussians', 5, 'LearningRate', learn_rate, 'InitialVariance', 30*30);
    for imgIndex = train_num + 2: img_num
        img = images{imgIndex};
        for temIndex = imgIndex - train_num - 1: imgIndex - 1
            fg_tmp = step(detector, images{temIndex});
        end
        diff_mask{imgIndex} = step(detector, img);
        reset(detector);
    end
    diff_mask{1} = diff_mask{2};
    
    % Morphology process.
    m0 = [1, 0, 1; 0, 0, 0; 1, 0, 1];
    m1 = [0, 1, 0; 1, 0, 1; 0, 1, 0];
    m2 = [1, 1, 1; 1, 1, 1; 1, 1, 1];
    
    for imgIndex = 1:img_num     
        diff = diff_mask{imgIndex};
%         diff = imerode(diff, m0) | imerode(diff, m1);
        diff = imdilate(diff, m2);
        init_mask{imgIndex} = diff;
        subplot(1, 2, 1);
        imshow(diff_mask{imgIndex});
        subplot(1, 2, 2);
        imshow(init_mask{imgIndex});
        set(gcf, 'name', ['Image ' num2str(imgIndex)], 'numbertitle', 'off');
        pause(0.1);
    end
end