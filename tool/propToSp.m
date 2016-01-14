% Function to find corresponding superpixel according to proposals
% selected.
% Input
%   - props: Proposals selected.
%   - sp: Map of superpixels.
% Output
%   - sp_index: Index of superpixels selected.
% Writen by chenzy.

function sp_index = propToSp(props, sp)
    prop_num = length(props);
    sp_num = max(sp(:));
    [height, width] = size(sp);
    
    % Convert proposals into pixels.
    img = false(height, width);
    for index = 1:prop_num
        img = img | props{index};
    end
    
    % Find superpixels with pixels included.
    sp_index = false(sp_num, 1);
    for index = 1:sp_num
        if sum(sum(img(sp == index))) > 0
            sp_index(index) = 1;
        end
    end
end