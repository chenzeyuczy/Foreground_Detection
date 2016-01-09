% Script to get initial mask from videos.

% import_data;

video_num = 5;

videoIndex = 5;
images = data_info{videoIndex}.data;
% gts = data_info{videoIndex}.gt;
img_num = length(images);

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
toc();

for imgIndex = 1:img_num
    mask = init_mask{imgIndex};
    imshow(mask);
    set(gcf, 'name', ['Image ' num2str(imgIndex)], 'numbertitle', 'off');
    fprintf('Image %d in video %d.\n', imgIndex, videoIndex);
    filePath = [pwd '/result/' num2str(videoIndex) '_' num2str(imgIndex) '.png'];
    imwrite(mask, filePath);
    pause(0.1);
end