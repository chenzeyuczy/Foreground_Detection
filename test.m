% This is a script for test.

image = data_info{3}.data{18};

% sp_map = gen_sp(image, opts);
% post_sp_map = process_sp_map(sp_map);

saliency_map = manifold_ranking(image, opts);
binary_map = im2bw(saliency_map, multithresh(saliency_map));

figure(1);
imshow(saliency_map);
figure(2);
imshow(binary_map);