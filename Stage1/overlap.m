function overlap_ratio = overlap(image1, image2)
    image1 = im2bw(image1);
    image2 = im2bw(image2);
    overlap_ratio = sum(image1(:) & image2(:)) / sum(image1(:) | image2(:));
end