% This a functin to generate foreground proposal from an image.
% Writen by chenzy.

function mask = get_foreground(img, preMask)
    % Generate superpixel.
    sp_map = gen_sp(img, opts);
    sp_map = process_sp_map(sp_map);
    
    % Get initial foreground proposal.
    if nargin > 1
        initMask = getInitMask(sp_map, preMask);
    else
        initMask = defaultMask;
    end
    
    % Generate foreground proposal with manifold ranking.
    mask = manifold_ranking(img, initMask);
end