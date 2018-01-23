function testLightNorms()
    for i = 1:num_imgs
    figure();
    imshow(img_cell{i});
    x_beg = center(1);
    y_beg = center(2);
    x_end = x_beg + light_dirs_5x3(i,1);
    y_end = y_beg + light_dirs_5x3(i,2);
    line([x_beg, x_end], [y_beg, y_end])
    end
end
