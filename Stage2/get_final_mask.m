% Script to generate final mask from videos.

video_num = 5;

for video_index = 1:video_num
    video_name = data_info{video_index}.data_name;
    images = data_info{video_index}.data;
    gts = data_info{video_index}.gt;
    masks = foreground{video_index};

    img_num = length(images);
    pcs1 = zeros(img_num, 1);
    pcs2 = zeros(img_num, 1);
    rc1 = zeros(img_num, 1);
    rc2 = zeros(img_num, 1);

    tic();
    for img_index = 1:img_num
        img = images{img_index};
        mask = masks{img_index};
        gt = gts{img_index};
        saliency1 = MR_image(img, opts, mask);
        saliency2 = im2bw(saliency1, graythresh(saliency1));
    end
    time2(video_index) = toc();
    fprintf('Process video %d in %s seconds.\n', video_index, time2(video_index));
    avg_time2(video_index) = time2(video_index) / img_num;
    fprintf('%f seconds per frame in stage 2.\n', avg_time2(video_index));
    
    for img_index = 1:img_num
        % Evaluate performance.
        [pcs1(img_index), rc1(img_index), ~] = get_hit_rate(mask, gt);
        [pcs2(img_index), rc2(img_index), ~] = get_hit_rate(saliency2, gt);

        % Show image.
        subplot(1, 3, 1);
        imshow(mask);
        subplot(1, 3, 2);
        imshow(saliency1);
        subplot(1, 3, 3);
        imshow(saliency2);
        set(gcf, 'name', ['Image ' num2str(imgIndex)], 'numbertitle', 'off');

        % Save result.
        result_folder = [pwd '/result/stage2/' num2str(video_index)];
        result_path = [result_folder '/' num2str(img_index) '.png'];
        if exist(result_folder) ~= 7
            mkdir(result_folder);
        end
        imwrite(saliency2, result_path);

        pause(0.3);
    end
    
    precision1{video_index} = pcs1;
    recall1{video_index} = rc1;
    precision1{video_index} = pcs2;
    recall2{video_index} = rc2;

    % Draw image.
    subplot(1, 1, 1);
    hold on;
    plot(pcs1, 'Color', 'r', 'LineWidth', 1, 'LineStyle', '-', 'Marker', 'o');
    plot(rc1, 'Color', 'g', 'LineWidth', 1, 'LineStyle', '--', 'Marker', '+');
    plot(pcs2, 'Color', 'b', 'LineWidth', 1, 'LineStyle', ':', 'Marker', '*');
    plot(rc2, 'Color', 'y', 'LineWidth', 1, 'LineStyle', '-.', 'Marker', 'x');
    axis([0, inf, 0, 1]);
    set(gcf, 'name', ['Video ' num2str(video_index)], 'numbertitle', 'off');
    title(video_name);
    xlabel('Frame Sequence');
    legend('Precision1', 'Recall1', 'Precision2', 'Recall2');
    hold off;
    img_path = 'result/stage2/performance/';
    if exist(img_path) ~= 7
        mkdir(img_path);
    end
    saveas(gcf, [img_path, video_name '.jpg']);
end