% This is a script for test.

video_num = 5;
avg_time = cell(video_num, 1);
for videoIndex = 1:video_num
    img_num = length(data_info{videoIndex}.data);
    avg_time{videoIndex} = t{videoIndex} / img_num;
    fprintf('Average processing time for video %d: %f\n', videoIndex, avg_time{videoIndex});
end