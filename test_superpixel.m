function test_superpixel()
    import_data;
    
    videoIndex = 4;
    images = data_info{videoIndex}.data;
    img_num = length(images);
    
    opts.slic_regionsize = 20;
    opts.slic_regularizer = 0.1;
    opts.slic_minregionsize = 100;
    opts.show_sp_map = 0;
    
    for img_index = 3
        img = images{img_index};
        sp = process_sp_map(gen_sp(img, opts));
        
        sp_num = max(sp(:));
        for sp_index = 1:sp_num
            sp_region = (sp == sp_index);
            imshow(sp_region);
            pause(0.1);
        end
%         show_sp_map(img, sp, opts.slic_regionsize, opts.slic_regularizer);
%         set(gcf, 'name', ['Image ' num2str(img_index)], 'numbertitle', 'off');
%         pause(1.0);
    end
end