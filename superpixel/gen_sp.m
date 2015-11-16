% superpixel generation: slic or xx?
% sp_map: int 32 mat, i.e., sp ind of each pixel
% opts: parameter struct in param_intial.m

% Attention: some indicies in sp_map are missed! This is caused by slic.
% So I post_processed sp_map in process_sp_map.m
 
function sp_map = gen_sp(img, opts)

    img_lab = vl_xyz2lab(vl_rgb2xyz(img));  % Convert image from RGB to LAB color space.
    % SLIC in lab space is better
    img_lab = im2single(img_lab);
    sp_map = vl_slic(img_lab, opts.slic_regionsize, opts.slic_regularizer);	 % uint32 mat: ind of each pixel
    if opts.show_sp_map == 1
        show_sp_map(img, sp_map, opts);
    end

end
