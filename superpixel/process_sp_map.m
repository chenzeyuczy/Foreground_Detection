% Fix bug brought by slic in vlfeat, integrated by chenzy.

function post_sp_map = process_sp_map(sp_map)
    % Assign different labels for unconnected superpixels with the same index.
    post_sp_map = sp_map;
	[hig, wid] = size(sp_map);
	[~, ~, ic] = unique(reshape(post_sp_map, hig*wid, 1)); 
	post_sp_map = reshape(ic, hig, wid);
	spNumber = max(post_sp_map(:));         
	spCounter = 0;
	for ii = 1:spNumber
	    CC = bwconncomp(logical(post_sp_map == ii), 8);
	    for u = 2:CC.NumObjects % If there is more than one component
	        indexList = CC.PixelIdxList{u};
	        spCounter = spCounter + 1;
	        post_sp_map(indexList) = spNumber + spCounter; % Assign a new superpixel label
	    end
    end
    
    % Produce successive indices, ranging from 1 to max_ind.
    sp_ind = sort(unique(post_sp_map),'ascend');
	ind_imagined = (0:max(max(post_sp_map)))';
	if ~isequal(sp_ind,ind_imagined)
		for i = 1:length(sp_ind)
			post_sp_map(post_sp_map==sp_ind(i)) = i;
		end
	end
end