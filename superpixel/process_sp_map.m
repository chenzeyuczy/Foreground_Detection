% Explanation: process sp map to produce successive indices, [0:max_ind-1]
% GCC, 2015-9-7

function post_sp_map = process_sp_map(sp_map)
	sp_ind = sort(unique(sp_map),'ascend');
	ind_imagined = (0:max(max(sp_map)))';
	post_sp_map = sp_map;
	if ~isequal(sp_ind,ind_imagined)
		for i = 1:length(sp_ind)
			post_sp_map(sp_map==sp_ind(i)) = i - 1;
		end
	end
end