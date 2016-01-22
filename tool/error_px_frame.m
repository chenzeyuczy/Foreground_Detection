% Calculate error pixels per frame in each vidoe.
video_num = 5;

err_perframe1 = zeros(video_num, 1);
err_perframe2 = zeros(video_num, 1);

for video_index = 1:video_num
    img_num = length(data_info{video_index}.data);
    err_per_frame1(video_index) = sum(error_pixel1{video_index}) / img_num;
    err_per_frame2(video_index) = sum(error_pixel2{video_index}) / img_num;
    fprintf('Error pixels per frame of video %d in stage 1: %f\n', video_index, err_per_frame1(video_index));
    fprintf('Error pixels per frame of video %d in stage 2: %f\n', video_index, err_per_frame2(video_index));
end