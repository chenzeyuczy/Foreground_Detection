% Script to get initial mask from videos.

% clear all;
% import_data;

% video_num = 5;
% precision = cell(video_num, 1);
% recall = cell(video_num, 1);
% error_rate = cell(video_num, 1);
% foreground = cell(video_num, 1);
% t = zeros(video_num, 1);
% avg_time = zeros(video_num, 1);

for videoIndex = 1
    images = data_info{videoIndex}.data;
    gts = data_info{videoIndex}.gt;
    img_num = length(images);
    
    precision{videoIndex} = zeros(img_num, 1);
    recall{videoIndex} = zeros(img_num, 1);

    fprintf('Processing video %d...\n', videoIndex);
    tic();
    switch videoIndex
        case 1
            init_mask = get_init_mask_1(images);
        case 2
            init_mask = get_init_mask_2(images);
        case 3
            init_mask = get_init_mask_3(images);
        case 4
            init_mask = get_init_mask_4(images);
        case 5
            init_mask = get_init_mask_5(images);
    end
    foreground{videoIndex} = init_mask;
    t(videoIndex) = toc();
    fprintf('Process video %d in %s seconds.\n', videoIndex, t(videoIndex));
    avg_time(videoIndex) = t(videoIndex) / img_num;
    fprintf('%f seconds per frame.\n', avg_time(videoIndex));

    for imgIndex = 1:img_num
        mask = foreground{videoIndex}{imgIndex};
        gt = gts{imgIndex};

        % Calculate performance.
        [pcs, rc, err] = get_hit_rate(mask, gt);
        fprintf('Image %d in video %d.\n', imgIndex, videoIndex);
        fprintf('Accuracy: %f, Recall: %f. Error: %f.\n', pcs, rc, err);
        precision{videoIndex}(imgIndex) = pcs;
        recall{videoIndex}(imgIndex) = rc;
        error_rate{videoIndex}(imgIndex) = err;

        % Show image.
        subplot(1, 2, 1);
        imshow(mask);
        subplot(1, 2, 2);
        imshow(gt);
        set(gcf, 'name', ['Image ' num2str(imgIndex)], 'numbertitle', 'off');

        % Save result.
        filePath = [pwd '/result/' num2str(videoIndex) '/' num2str(imgIndex) '.png'];
        result_path = [pwd '/result/' num2str(videoIndex)];
        if exist(result_path) ~= 7
            mkdir(result_path);
        end
        imwrite(mask, filePath);

%         pause(0.6);
    end
end