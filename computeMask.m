%{
    Computes a mask based on all the images in img_cell (vases in this homework)

    Documentation:
        if any of the imgs in img_cell have a nonzero pixel at (x_i, y_i),
            mask(x_i, y_i) = 1
        else
            mask(x_i, y_i) = 0


%}
function mask = computeMask(img_cell)
    DEBUG = 0;

    [num_imgs, num_fields,per_cell] = size(img_cell);
    [height, length] = size(img_cell{1});
    mask = zeros(height,length);

    ANY_PIX = 0.00001; % make smaller if not picking something up
    for i=1:num_imgs
        img = im2bw(img_cell{i},ANY_PIX);
        mask = mask + img;

        if DEBUG
            figure();
            imshow(mask);
        end
    end
    mask = im2bw(mask);

