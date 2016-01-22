% Generate a saliency map using manifold ranking algorithm.
% Input
%   - image: Image to be processed.
%   - opts: Options for SLIC algorithm.
% Output:
%   - saliency_map: The saliency map for image, ranging from 0 to 1.

function saliency_map = MR_image(image, opts, mask)
    %%---------------parameter initialization------------%%
    theta = 10; % control the edge weight 
    alpha = 0.99; % control the balance of two items in manifold ranking cost function
    [height, width, dim] = size(image);
    img_size = height * width;

    %%----------------------generate superpixels--------------------%%
    superpixels = process_sp_map(gen_sp(image, opts));
    sp_num = max(superpixels(:)); % the actual superpixel number

    %%----------------------design the graph model--------------------------%%
    % compute the feature (mean color in lab color space) 
    % for each node (superpixels)
    input_vals = reshape(image, height * width, dim);
    rgb_vals = zeros(sp_num, 1, 3);
    inds = cell(sp_num, 1);
    for i = 1:sp_num
        inds{i} = find(superpixels == i);
        rgb_vals(i,1,:) = mean(input_vals(inds{i},:), 1);
    end
    lab_vals = rgb2lab(rgb_vals);
    seg_vals = reshape(lab_vals, sp_num, 3); % feature for each superpixel
 
    % get edges
    adjloop = AdjcProcloop(superpixels, sp_num);
    edges = [];
    for i = 1:sp_num
        indext = [];
        ind = find(adjloop(i,:) == 1);
        for j = 1:length(ind)
            indj = find(adjloop(ind(j),:) == 1);
            indext = [indext, indj];
        end
        indext = [indext, ind];
        indext = indext((indext>i));
        indext = unique(indext);
        if (~isempty(indext))
            ed = ones(length(indext), 2);
            ed(:,2) = i;
            ed(:,1) = indext;
            edges = [edges; ed];
        end
    end

    % compute affinity matrix
    weights = makeweights(edges, seg_vals, theta);
    W = adjacency(edges, weights, sp_num);

    % learn the optimal affinity matrix (eq. 3 in paper)
    D = sparse(1:sp_num, 1:sp_num, sum(W));
    optAff = (D-alpha*W)\eye(sp_num);
    optAff = optAff.*(~diag(ones(sp_num,1)));
  
    %%----------------------stage2-------------------------%%
    
    query = score_superpixel(superpixels, mask);
    
    % compute the saliency value for each superpixel
    fsal = optAff * query;
    
    % assign the saliency value to each pixel
    tmap = zeros(height, width);
    for i = 1:sp_num
        tmap(inds{i}) = fsal(i);
    end
    % normalize saliency map
    tmap = (tmap-min(tmap(:)))/(max(tmap(:))-min(tmap(:)));

    saliency_map = tmap;
%     
%     fg_map = im2bw(saliency_map, graythresh(saliency_map));
%     fg_size = sum(fg_map(:));
%     
%     max_fg_ratio = 0.15;
%     if fg_size / img_size > max_fg_ratio
%         bg_query = 1 - fsal;
%         bsal = optAff * bg_query;
%         fsal = 1 - bsal;
%         % assign the saliency value to each pixel
%         tmap = zeros(height, width);
%         for i = 1:sp_num
%             tmap(inds{i}) = fsal(i);    
%         end
%         % normalize saliency map
%         tmap = (tmap-min(tmap(:)))/(max(tmap(:))-min(tmap(:)));
% 
%         saliency_map = tmap;     
%     end
end
