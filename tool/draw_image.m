% Script to draw image for presentation.

video_num = 5;

for video_index = 1:video_num
    img_num = length(images{video_index});
    video_name = data_info{video_index}.data_name;
    acc = accuracy{video_index};
    rc = recall{video_index};
    err = error_rate{video_index};
    clf();
    hold on;
    plot(acc, 'Color', 'r', 'LineWidth', 1);
    plot(rc, 'Color', 'g', 'LineWidth', 1);
%     plot(err, 'Color', 'b', 'LineWidth', 1);
    axis([0, inf, 0, 1]);
    set(gcf, 'name', ['Video ' num2str(video_index)], 'numbertitle', 'off');
    title(video_name);
    xlabel('Frame Sequence');
    legend('Accuracy', 'Recall');
    hold off;
    img_path = 'result/performance/';
    if exist(img_path) ~= 7
        mkdir(img_path);
    end
    saveas(gcf, [img_path, video_name '.jpg']);
    pause(0.3);
end