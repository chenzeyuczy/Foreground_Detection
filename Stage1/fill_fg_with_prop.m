% Function to fill foreground with proposal.
% Input
%	init_fg: Initial foreground mask.
%	props: Proposals of image.
%	top_rank: Number of proposals selected to be merge.
% Output
%	mask: Mask for final foreground result.
% Writen by GCC & chenzy.

function mask = fill_fg_with_prop(init_fg, props, top_rank)
	if nargin < 3
		top_rank = 2;
	end

	mask = init_fg;
	init_fg = imfill(init_fg, 'holes');
	prop_num = length(props);
	overlap_ratio = zeros(prop_num, 1);
	for prop_index = 1:prop_num
		prop = props{prop_index};
		% Skip proposals that have been involved in the initial mask.
		if ~isequal((init_fg & prop), prop)
			overlap_ratio(prop_index) = get_overlap(init_fg, prop);
		end
	end
	[~, idx] = sort(overlap_ratio, 'descend');
	for index = 1:top_rank
		mask = mask | props{idx(index)};
	end
end