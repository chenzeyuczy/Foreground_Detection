% Generate a saliency map using manifold ranking algorithm.
% Input
%   - image: Image to be processed.
% Output:
%   - saliency_map: The saliency map for image, ranging from 0 to 1.

function saliency_map = get_saliency(image)
    theta = 10; % control the edge weight 
    alpha = 0.99; % control the balance of two items in manifold ranking cost function
    spnumber = 200; % superpixel number
    sup_dir = './test/'; % the superpixel label file path
    im_name = 'temp.bmp';
    imwrite(image, im_name);
    [image, w] = removeframe(im_name); % run a pre-processing to remove the image frame 
    [height, width, k] = size(image);
    
    %%----------------------generate superpixels--------------------%%
    im_name = [im_name(1:end-4) '.bmp']; % the slic software support only the '.bmp' image
    comm = ['SLICSuperpixelSegmentation' ' ' im_name ' ' int2str(20) ' ' int2str(spnumber) ' ' sup_dir];
    system(comm);    
    sp_name = [sup_dir im_name(1:end-4)  '.dat'];
    superpixels = ReadDAT([height,width], sp_name); % superpixel label matrix
    sp_num = max(superpixels(:)); % the actual superpixel number

    delete(im_name);
    delete(sp_name);

    %%----------------------design the graph model--------------------------%%
    % compute the feature (mean color in lab color space) 
    % for each node (superpixels)
    input_vals = reshape(image, height*width, k);
    rgb_vals = zeros(sp_num,1,3);
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
        indext = [indext,ind];
        indext = indext((indext > i));
        indext = unique(indext);
        if(~isempty(indext))
            ed = ones(length(indext), 2);
            ed(:,2) = i * ed(:, 2);
            ed(:,1) = indext;
            edges = [edges; ed];
        end
    end

    % compute affinity matrix
    weights = makeweights(edges,seg_vals, theta);
    W = adjacency(edges,weights,sp_num);

    % learn the optimal affinity matrix (eq. 3 in paper)
    dd = sum(W); D = sparse(1:sp_num, 1:sp_num, dd); clear dd;
    optAff = (D-alpha*W)\eye(sp_num); 
    mz = diag(ones(sp_num,1));
    mz = ~mz;
    optAff = optAff.*mz;

    %%-----------------------------stage 1--------------------------%%
    % compute the saliency value for each superpixel 
    % with the top boundary as the query
    Yt = zeros(sp_num,1);
    bst = unique(superpixels(1,1:width));
    Yt(bst) = 1;
    bsalt = optAff*Yt;
    bsalt = (bsalt-min(bsalt(:)))/(max(bsalt(:))-min(bsalt(:)));
    bsalt = 1-bsalt;

    % down
    Yd = zeros(sp_num,1);
    bsd = unique(superpixels(height,1:width));
    Yd(bsd) = 1;
    bsald = optAff*Yd;
    bsald = (bsald-min(bsald(:)))/(max(bsald(:))-min(bsald(:)));
    bsald = 1-bsald;

    % right
    Yr = zeros(sp_num,1);
    bsr = unique(superpixels(1:height,1));
    Yr(bsr) = 1;
    bsalr = optAff*Yr;
    bsalr = (bsalr-min(bsalr(:)))/(max(bsalr(:))-min(bsalr(:)));
    bsalr = 1-bsalr;

    % left
    Yl = zeros(sp_num,1);
    bsl = unique(superpixels(1:height,width));
    Yl(bsl) = 1;
    bsall = optAff*Yl;
    bsall = (bsall-min(bsall(:)))/(max(bsall(:))-min(bsall(:)));
    bsall = 1-bsall;   

    % combine 
    bsalc = (bsalt.*bsald.*bsall.*bsalr);
    bsalc = (bsalc-min(bsalc(:)))/(max(bsalc(:))-min(bsalc(:)));

    % assign the saliency value to each pixel     
     tmapstage1 = zeros(height, width);
     for i = 1:sp_num
        tmapstage1(inds{i}) = bsalc(i);
     end
     tmapstage1 = (tmapstage1-min(tmapstage1(:)))/(max(tmapstage1(:))-min(tmapstage1(:)));

    %%----------------------stage2-------------------------%%
    % binary with an adaptive threhold (i.e. mean of the saliency map)
    th = mean(bsalc);
    bsalc(bsalc < th) = 0;
    bsalc(bsalc >= th) = 1;

    % compute the saliency value for each superpixel
    fsal = optAff * bsalc;    

    % assign the saliency value to each pixel
    tmapstage2=zeros(height,width);
    for i = 1:sp_num
        tmapstage2(inds{i}) = fsal(i);    
    end
    tmapstage2 = (tmapstage2-min(tmapstage2(:)))/(max(tmapstage2(:))-min(tmapstage2(:)));

    mapstage2 = zeros(w(1),w(2));
    mapstage2(w(3):w(4),w(5):w(6)) = tmapstage2;
       
    saliency_map = mapstage2;
end
