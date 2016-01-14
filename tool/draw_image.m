% Script to draw image for presentation.

video_num = 5;

for video_index = 1:video_num
    img_num = length(images{video_index});
    acc = accuracy{video_index};
    rc = recall{video_index};
    err = error_rate{video_index};
    clf();
    hold on;
    plot(acc, 'Color', 'r', 'LineWidth', 1);
    plot(rc, 'Color', 'g', 'LineWidth', 1);
    plot(err, 'Color', 'b', 'LineWidth', 1);
    set(gcf, 'name', ['Video ' num2str(video_index)], 'numbertitle', 'off');
    xlabel('Frame number');
    legend('Accuracy', 'Recall', 'Error');
    hold off;
    pause();
end