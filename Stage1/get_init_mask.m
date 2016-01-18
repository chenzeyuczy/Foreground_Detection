% Script to get initial mask from videos.

% clear all;
% import_data;

video_num = 5;
precision = cell(video_num, 1);
recall = cell(video_num, 1);
error_rate = cell(video_num, 1);
foreground = cell(video_num, 1);
t = zeros(video_num, 1);
avg_time = zeros(video_num, 1);

for video_index = 1:video_num
    images = data_info{video_index}.data;
    gts = data_info{video_index}.gt;
    img_num = length(images);
    
    precision{video_index} = zeros(img_num, 1);
    recall{video_index} = zeros(img_num, 1);

    fprintf('Processing video %d...\n', video_index);
    tic();
    switch video_index
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
    foreground{video_index} = init_mask;
    t(video_index) = toc();
    fprintf('Process video %d in %s seconds.\n', video_index, t(video_index));
    avg_time(video_index) = t(video_index) / img_num;
    fprintf('%f seconds per frame.\n', avg_time(video_index));

    for imgIndex = 1:img_num
        mask = foreground{video_index}{imgIndex};
        gt = gts{imgIndex};

        % Evaluate performance.
        [pcs, rc, err] = get_hit_rate(mask, gt);
        fprintf('Image %d in video %d.\n', imgIndex, video_index);
        fprintf('Accuracy: %f, Recall: %f. Error: %f.\n', pcs, rc, err);
        precision{video_index}(imgIndex) = pcs;
        recall{video_index}(imgIndex) = rc;
        error_rate{video_index}(imgIndex) = err;

        % Show image.
        subplot(1, 2, 1);
        imshow(mask);
        subplot(1, 2, 2);
        imshow(gt);
        set(gcf, 'name', ['Image ' num2str(imgIndex)], 'numbertitle', 'off');

        % Save result.
        result_folder = [pwd '/result/stage1/' num2str(video_index)];
        result_path = [result_folder '/' num2str(imgIndex) '.png'];
        if exist(result_folder) ~= 7
            mkdir(result_folder);
        end
        imwrite(mask, result_path);

%         pause(0.6);
    end
end