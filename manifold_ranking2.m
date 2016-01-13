% Generate a saliency map using manifold ranking algorithm.
% Input
%   - input_im: Image to be processed.
%   - opts: Options for SLIC algorithm.
% Output:
%   - saliency_map: The saliency map for image, ranging from 0 to 1.

function saliency_map = manifold_ranking2(input_im, opts)
    %%---------------parameter initialization------------%%
    theta = 10; % control the edge weight 
    alpha = 0.99; % control the balance of two items in manifold ranking cost function
    [m, n, k] = size(input_im);

    %%----------------------generate superpixels--------------------%%
    tmp_img_name = 'temp_img.bmp';
    sp_dir = 'test/';
    sp_num = 200;
    imwrite(input_im, tmp_img_name);
    command = ['SLICSuperpixelSegmentation' ' ' tmp_img_name ' ' int2str(20) ' ' int2str(sp_num) ' ' sp_dir];
    system(command);
    spname = [sp_dir tmp_img_name(1:end-4)  '.dat'];
    superpixels = ReadDAT([m,n], spname); % superpixel label matrix
    
%     superpixels = process_sp_map(gen_sp(input_im, opts));
    spnum = max(superpixels(:)); % the actual superpixel number

    %%----------------------design the graph model--------------------------%%
    % compute the feature (mean color in lab color space) 
    % for each node (superpixels)
    input_vals = reshape(input_im, m*n, k);
    rgb_vals = zeros(spnum,1,3);
    inds = cell(spnum, 1);
    for i = 1:spnum
        inds{i} = find(superpixels==i);
        rgb_vals(i,1,:) = mean(input_vals(inds{i},:),1);
    end
    lab_vals = colorspace('Lab<-', rgb_vals);
    seg_vals = reshape(lab_vals, spnum, 3); % feature for each superpixel
 
    % get edges
    adjloop = AdjcProcloop(superpixels, spnum);
    edges = [];
    for i = 1:spnum
        indext = [];
        ind = find(adjloop(i,:)==1);
        for j = 1:length(ind)
            indj = find(adjloop(ind(j),:)==1);
            indext = [indext,indj];
        end
        indext = [indext,ind];
        indext = indext((indext>i));
        indext = unique(indext);
        if (~isempty(indext))
            ed = ones(length(indext),2);
            ed(:,2) = i;
            ed(:,1) = indext;
            edges = [edges;ed];
        end
    end

    % compute affinity matrix
    weights = makeweights(edges,seg_vals,theta);
    W = adjacency(edges,weights,spnum);

    % learn the optimal affinity matrix (eq. 3 in paper)
    D = sparse(1:spnum,1:spnum,sum(W));
    optAff = (D-alpha*W)\eye(spnum);
    optAff = optAff.*(~diag(ones(spnum,1)));
  
    %%-----------------------------stage 1--------------------------%%
    % compute the saliency value for each superpixel 
    % with the top boundary as the query
    Yt = zeros(spnum,1);
    Yt(unique(superpixels(1,1:n))) = 1;
    bsalt = optAff*Yt;
    bsalt = (bsalt-min(bsalt(:)))/(max(bsalt(:))-min(bsalt(:)));
    bsalt = 1-bsalt;

    % down
    Yd = zeros(spnum,1);
    Yd(unique(superpixels(m,1:n))) = 1;
    bsald = optAff*Yd;
    bsald = (bsald-min(bsald(:)))/(max(bsald(:))-min(bsald(:)));
    bsald = 1-bsald;
   
    % right
    Yr = zeros(spnum,1);
    Yr(unique(superpixels(1:m,1))) = 1;
    bsalr = optAff*Yr;
    bsalr = (bsalr-min(bsalr(:)))/(max(bsalr(:))-min(bsalr(:)));
    bsalr = 1-bsalr;
  
    % left
    Yl = zeros(spnum,1);
    Yl(unique(superpixels(1:m,n))) = 1;
    bsall = optAff*Yl;
    bsall = (bsall-min(bsall(:)))/(max(bsall(:))-min(bsall(:)));
    bsall = 1-bsall;   
   
    % combine 
    bsalc = (bsalt.*bsald.*bsall.*bsalr);
    bsalc = (bsalc-min(bsalc(:)))/(max(bsalc(:))-min(bsalc(:)));

    %%----------------------stage2-------------------------%%
    % binary with an adaptive threhold (i.e. mean of the saliency map)
    th = mean(bsalc);
    bsalc(bsalc<th) = 0;
    bsalc(bsalc>=th) = 1;
    
    % compute the saliency value for each superpixel
    fsal = optAff*bsalc;    
    
    % assign the saliency value to each pixel
    tmap = zeros(m,n);
    for i = 1:spnum
        tmap(inds{i}) = fsal(i);    
    end
    tmap = (tmap-min(tmap(:)))/(max(tmap(:))-min(tmap(:)));

    saliency_map = zeros(m,n);
    saliency_map(1:m,1:n) = tmap;
    
end
