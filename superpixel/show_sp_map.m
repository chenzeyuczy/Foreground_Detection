% show slic results, require vl_feat
% sp_map = gen_sp(img, opts);

function [] = show_sp_map(img, sp_map, opts )
	
    [sx,sy] = vl_grad(double(sp_map), 'type', 'forward') ;
    s = find(sx | sy) ;
    % Find boundaries among superpixels.
    imp = img ;
    imp([s s+numel(img(:,:,1)) s+2*numel(img(:,:,1))]) = 0 ;
    % Outline the boundaries.

    % imagesc(imp) ; 
    imshow(imp,[]);
    axis image off ;
    hold on ;
    text(5, 5, sprintf('regionSize:%.2g\nregularizer:%.2g', opts.slic_regionsize, opts.slic_regularizer), ...
         'Background', 'white', 'VerticalAlignment', 'top')

end
