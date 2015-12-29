% Script to get initial mask from videos.

% import_data;

video_num = 5;
% init_prop = cell(video_num, 1);

videoIndex = 3;
images = data_info{videoIndex}.data;
gts = data_info{videoIndex}.gt;
img_num = length(images);

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

for imgIndex = 1:img_num
    mask = init_mask{imgIndex};
    imshow(mask);
    fprintf('Image %d in video %d.\n', imgIndex, videoIndex);
    pause();
end