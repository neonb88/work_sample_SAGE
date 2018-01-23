%{
    @param gray_stack   stack of grayscale images of the same scene, each focused to a different degree
                    type = 'uint8'
    @param half_w_size = the length of one quarter of the total window, ie.

          half_w   half_w
         _________________
        |        |        |
        |        |        |
        |        |        | half_w_size
        |        |        |
         _________________
        |        |        |
        |        |        |
        |        |        |
        |        |        |
         _________________


%}
function index_map = generateIndexMap(gray_stack, half_w_size)
    DEBUG = 0;
    SINGLE_PIXEL = 0; % should rarely be the case; just for testing

    % For grayscale images, imshow only works for integer values, not double (float) values  
    % However, del2() only works for integer (uint8) values, not double (float) values
    gray_stack = cast(gray_stack, 'double');         

    [height, len, num_imgs] = size(gray_stack);

    % Final Product:  gives which image is most focused at a particular pixel point
    %   Will eventually compress down to 2d matrix   (height x len)
    index_map_deep               = zeros(height, len, num_imgs); 
    % (del^2 f) / (del x)^2
    del_xs                  = zeros(height, len, num_imgs);
    % (del^2 f) / (del y)^2
    del_ys                  = zeros(height, len, num_imgs);

    % compute laplacians in x dir
    for img=1:num_imgs
        for y=1:height
            del_ys(y,:,img) = del2(gray_stack(y,:,img));
        end
    end

    % compute laplacians in y dir
    for img=1:num_imgs
        for x=1:len
            del_xs(:,x,img) = del2(gray_stack(:,x,img));
        end
    end
    % \/    max focus at a single point    \/
    focus_measures      = abs(del_ys) + abs(del_xs);
    %  smoothing out the focus_measures   as advised in the lab specifications
    filter_edge_dim     = 15;                          % dim x dim   convolution matrix
    sigma_std_dev       = 1;                        % how spread out the gaussian filter is
    gauss_filter        = fspecial('gaussian', filter_edge_dim, sigma_std_dev);
    focus_measures      = imfilter(focus_measures, gauss_filter);

    DOWN           = 1;
    ACROSS         = 2;
    focus_sums     = cumsum(cumsum(focus_measures, DOWN), ACROSS);
    TOP_EDGE       = 0;
    LEFT_EDGE      = 0;

    % the part that scans over all windows
    for img=1:num_imgs
        % y   over all heights
        for y=1:height
            top = y - half_w_size - 1; 
            bottom = y + half_w_size;

            %   check whether window extends to off-image
            if (top < 1)
                top = TOP_EDGE;
            end
            if (bottom > height)
                bottom = height;
            end 


            % x   over all horizontal distances
            for x=1:len
                left  = x - half_w_size - 1;
                right = x + half_w_size;
                %   check whether window extends to off-image
                if (left < 1)
                    left = LEFT_EDGE;
                end
                if (right > len)
                    right = len;
                end

                window_area             = (bottom - top) * (right - left);

            %  using the technique Professor Nayar showed us in class with cumulative sums

                % upper left corner
                if and(left == LEFT_EDGE, ...
                       top  == TOP_EDGE)
                    index_map_deep(y,x,img) = focus_sums(bottom, right, img) ...
                                            / window_area;
                else
                    % left edge
                    if (left == LEFT_EDGE)
                        index_map_deep(y,x,img) = (focus_sums(bottom, right, img)  ...
                                                 - focus_sums(top, right, img)) ...
                                                 / window_area;
                    else
                        % top edge
                        if (top == TOP_EDGE)
                            index_map_deep(y,x,img) = (focus_sums(bottom, right, img) ...
                                                     - focus_sums(bottom, left, img)) ...
                                                     / window_area;
                        % mid, right, or bot
                        else
                            index_map_deep(y,x,img) = (focus_sums(bottom, right, img)  ...
                                                     - focus_sums(bottom, left, img)   ...
                                                     - focus_sums(top, right, img)  ...
                                                     + focus_sums(top, left, img))  ...
                                                     / window_area;
                        end
                    end
                end


                % show grayscale imgs if DEBUG
                if DEBUG == 1
                    if (DEBUG == 100)
                        fig = figure();
                        imshow(window);
                        pause(2.0);
                        close(fig);
                        DEBUG = 0;
                    end
                    DEBUG = DEBUG + 1;
                end
            end
        end
    end

    % find best-focused photo at each pixel
    DEEP = 3;
    [max_focus_measures, single_layer_idx_map] = max(index_map_deep, [], DEEP);
    index_map = single_layer_idx_map;

    % should not be the case
    if (SINGLE_PIXEL)
        % this would work if the window size were 1x1 (single pixel at a time)
        [max_focus_measure, index_map] = max(focus_measures, [], DEEP);
    end






















































