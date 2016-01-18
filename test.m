% This is a script for test.

video_num = 5;

video_index = 4;
images = data_info{video_index}.data;
img_index = 3;
img = images{img_index};

[height, width, dim] = size(img);
reshape_img = reshape(img, [height * width, dim]);

opts.slic_regionsize = 20;
opts.slic_regularizer = 0.1;
opts.slic_minregionsize = 100;
opts.show_sp_map = 0;

tic();
sp_map = process_sp_map(gen_sp(img, opts));
sp_num = max(sp_map(:));
sp_feat = zeros(sp_num, dim);

for sp_index = 1:sp_num
    sp_region = sp_map == sp_index;
    sp_pos = find(sp_region);

    sp_feat(sp_index, :) = mean(reshape_img(sp_pos,:));

%     % Show superpixel.
%     mask_img = reshape_img;
%     mask_img(sp_map ~= sp_index,:) = 0;
%     mask_img = reshape(mask_img, [height, width, dim]);
%     subplot(1, 3, 2);
%     imshow(mask_img);
%     subplot(1, 3, 3);
%     imshow(img);
end
toc();