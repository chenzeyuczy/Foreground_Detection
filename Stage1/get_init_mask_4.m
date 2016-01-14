% Function to get initial mask from video 4.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_4(images)    
    img_num = length(images);
    init_mask = cell(img_num, 1);
    
    for imgIndex = 1:img_num
        img = images{imgIndex};
        saliency_map = get_saliency(img);
        otsu_threshold = multithresh(saliency_map);
        init_mask{imgIndex} = im2bw(saliency_map, otsu_threshold);
    end
    
    start_num = 6;
    
%     fprintf('Start matching proposal...\n');
%     max_prop_num = 100;
%     max_pair_select = 20;
%     for imgIndex = start_num:img_num
%         tic();
%         img1 = images{imgIndex};
%         img2 = images{imgIndex - 1};
%         init_mask{imgIndex} = select_proposal(img1, img2, init_mask{imgIndex - 1}, max_prop_num, max_pair_select);
%         t = toc();
%         fprintf('Match image %d in %s seconds.\n', imgIndex, t);
%     end
end