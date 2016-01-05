% Function to get initial mask from video 1.
% Input
%   images: Images from video.
% Output
%   init_mask: Initial mask for videos.
% Writen by chenzy.

function init_mask = get_init_mask_1(images)
    img_num = length(images);
    init_mask = cell(img_num, 1);
    for imgIndex = 1:img_num
        img1 = images{imgIndex};
        if imgIndex == 1
            img2 = images{imgIndex + 1};
        else
            img2 = images{imgIndex - 1};
        end
        thld = 0.985;
        diff = diff_between_images(img1, img2, thld);
        m0 = [1, 0, 1; 0, 0, 0; 1, 0, 1];
        m1 = [0, 1, 0; 1, 0, 1; 0, 1, 0];
        m2 = [0, 1, 0; 1, 1, 1; 0, 1, 0];
        diff = imerode(diff, m0) | imerode(diff, m1);
        diff = imdilate(diff, m2);
        init_mask{imgIndex} = diff;
    end
end