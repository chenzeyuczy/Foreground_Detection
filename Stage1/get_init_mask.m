% Script to get initial mask from videos.

video_num = 5;

for video_index = 1:video_index
    video_name = data_info{video_index}.data_name;
    images = data_info{video_index}.data;
    gts = data_info{video_index}.gt;
    img_num = length(images);
    
    precision1{video_index} = zeros(img_num, 1);
    recall1{video_index} = zeros(img_num, 1);
    error_pixel1{video_index} = zeros(img_num, 1);

    fprintf('Processing video %d...\n', video_index);
     
%     proposals{video_index} = cell(img_num, 1);
%     boxes{video_index} = cell(img_num, 1);
%     for img_index = 1:img_num
%         img = images{img_index};
%         [proposals{video_index}{img_index}, boxes{video_index}{img_index}] = get_proposal(img);
%     end
    
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
    init_fg{video_index} = init_mask;
    time1(video_index) = toc();
    fprintf('Process video %d in %s seconds.\n', video_index, time1(video_index));
    avg_time1(video_index) = time1(video_index) / img_num;
    fprintf('%f seconds per frame in stage 1.\n', avg_time1(video_index));

    for imgIndex = 1:img_num
        mask = init_fg{video_index}{imgIndex};
        gt = gts{imgIndex};

        % Evaluate performance.
        [pcs, rc, err] = get_hit_rate(mask, gt);
        fprintf('Image %d in video %d.\n', imgIndex, video_index);
        fprintf('Accuracy: %f, Recall: %f. Error: %f.\n', pcs, rc, err);
        precision1{video_index}(imgIndex) = pcs;
        recall1{video_index}(imgIndex) = rc;
        error_pixel1{video_index}(imgIndex) = err;

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

        pause(0.3);
    end
    
    % Draw image.
    pcs = precision1{video_index};
    rc = recall1{video_index};
    subplot(1, 1, 1);
    hold on;
    plot(pcs, 'Color', 'r', 'LineWidth', 1, 'LineStyle', '-', 'Marker', 'o');
    plot(rc, 'Color', 'g', 'LineWidth', 1, 'LineStyle', '--', 'Marker', '+');
    axis([0, inf, 0, 1]);
    set(gcf, 'name', ['Video ' num2str(video_index)], 'numbertitle', 'off');
    title(video_name);
    xlabel('Frame Sequence');
    legend('Precision', 'Recall');
    hold off;
    img_path = 'result/stage1/performance/';
    if exist(img_path) ~= 7
        mkdir(img_path);
    end
    saveas(gcf, [img_path, video_name '.jpg']);
end