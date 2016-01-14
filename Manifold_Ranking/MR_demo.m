% Demo for paper "Saliency Detection via Graph-Based Manifold Ranking" 
% by Chuan Yang, Lihe Zhang, Huchuan Lu, Ming-Hsuan Yang, and Xiang Ruan
% To appear in Proceedings of IEEE Conference on Computer Vision and Pattern Recognition (CVPR 2013), Portland, June, 2013.

function MR_demo()
    %%------------------------set parameters---------------------%%
    theta = 10; % control the edge weight 
    alpha = 0.99; % control the balance of two items in manifold ranking cost function
    imgRoot = '../../dataset/SegTrack_V1/monkeydog/'; % test image path
    saldir = './saliencymap/'; % the output path of the saliency map
    % mkdir(saldir);
    imnames = dir([imgRoot '*' 'bmp']);

    for ii = 1:length(imnames)   
        disp(ii);
        imname = [imgRoot imnames(ii).name]; 
        input_im = imread(imname);
        [m, n, k] = size(input_im);

    %%----------------------generate superpixels--------------------%%
        superpixels = process_sp_map(gen_sp(input_im, opts));
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

    % assign the saliency value to each pixel     
         tmapstage1 = zeros(m,n);
         for i = 1:spnum
            tmapstage1(inds{i}) = bsalc(i);
         end
         tmapstage1 = (tmapstage1-min(tmapstage1(:)))/(max(tmapstage1(:))-min(tmapstage1(:)));

         mapstage1 = zeros(m, n);
         mapstage1(1:m,1:n) = tmapstage1;
         mapstage1 = uint8(mapstage1*255);

    %      outname = [saldir imnames(ii).name(1:end-4) '_stage1' '.png'];
    %      imwrite(mapstage1, outname);

        subplot(1, 3, 1);
        imshow(mapstage1);

    %%----------------------stage2-------------------------%%
    % binary with an adaptive threhold (i.e. mean of the saliency map)
        th = mean(bsalc);
        bsalc(bsalc<th) = 0;
        bsalc(bsalc>=th) = 1;

    % compute the saliency value for each superpixel
        fsal = optAff*bsalc;    

    % assign the saliency value to each pixel
        tmapstage2 = zeros(m,n);
        for i = 1:spnum
            tmapstage2(inds{i}) = fsal(i);    
        end
        tmapstage2 = (tmapstage2-min(tmapstage2(:)))/(max(tmapstage2(:))-min(tmapstage2(:)));

        mapstage2 = zeros(m,n);
        mapstage2(1:m,1:n) = tmapstage2;
        mapstage2 = uint8(mapstage2*255);
    %     outname = [saldir imnames(ii).name(1:end-4) '_stage2' '.png'];   
    %     imwrite(mapstage2, outname);

        subplot(1, 3, 2);
        imshow(mapstage2);
        fgMap = im2bw(mapstage2, graythresh(mapstage2));
        subplot(1, 3, 3);
        imshow(fgMap);

        if ii < 8
            pause();
        else
            pause(0.8);
        end

    end
end