% This is a script writen by czy.

function saliency_map = manifold_ranking(image, superpixel)
    % Parameters initialization.
    alpha = 0.99;
    [height, width, ~] = size(image);
    sp_num = max(superpixel(:));
    
    % Transform color space.
    lab_image = rgb2lab(image);
    
    % Construct related matrix.
    % Still a long way to go.
    weight_matrix = construct_weight_matrix(lab_image);
    degree_matrix = sparse(1:sp_num, 1:spnum, sum(weight_matrix));
    
    opt_aff = (degree_matrix - alpha * weight_matrix) \ eye(sp_num);
    opt_aff = opt_aff * (~diag(ones(sp_num, 1)));
    
    % Query from four boundaries.
    query_top = zeros(sp_num, 1);
    query_top(unique(superpixel(1, 1:width))) = 1;
    saliency_top = opt_aff * query_top;
    saliency_top = 1 - (saliency_top - min(saliency_top(:))) / (max(saliency_top(:)) - min(saliency_top(:)));
    
    query_bottom = zeros(sp_num, 1);
    query_bottom(unique(superpixel(height, 1:width))) = 1;
    saliency_bottom = opt_aff * query_bottom;
    saliency_bottom = 1 - (saliency_bottom - min(saliency_bottom(:))) / (max(saliency_bottom(:)) - min(saliency_bottom(:)));
    
    query_left = zeros(sp_num, 1);
    query_left(unique(superpixel(1:height, 1))) = 1;
    saliency_left = opt_aff * query_left;
    saliency_left = 1 - (saliency_left - min(saliency_left(:))) / (max(saliency_left(:)) - min(saliency_left(:)));
    
    query_right = zeros(sp_num, 1);
    query_right(unique(superpixel(1:height, width))) = 1;
    saliency_right = opt_aff * query_right;
    saliency_right = 1 - (saliency_right - min(saliency_right(:))) / (max(saliency_right(:)) - min(saliency_right(:)));
    
    saliency_map = saliency_top .* saliency_bottom .* saliency_left .* saliency_right;
    saliency_map = (saliency_map - min(saliency_map(:))) / (max(saliency_map(:)) - min(saliency_map(:)));
    
end
