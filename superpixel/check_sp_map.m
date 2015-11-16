% check sp to fix the bug brought by slic in VL_feat
% assign different labels for unconnected sp with the same index
% GCC, 2015-9-13

function segments = check_sp_map(sp_map)
	segments = sp_map;
	[hig, wid] = size(sp_map);
	[~, ~, ic] = unique(reshape(segments, hig*wid, 1)); 
	segments = reshape(ic, hig, wid);
	numOfSP = max(segments(:));         
	counterOfSP = 0;
	for ii = 1:numOfSP
	    CC = bwconncomp(logical(segments == ii),8);
	    
	    for u = 2:CC.NumObjects % if there is more than one component
	        indexList = CC.PixelIdxList{u};
	        counterOfSP = counterOfSP + 1;
	        segments(indexList) = numOfSP + counterOfSP; % give a new superpixel label
	    end
	end
	segments = segments - 1;    % Make sp_map begin from 0
end

