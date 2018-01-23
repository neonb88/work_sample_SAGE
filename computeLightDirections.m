%{
    Computes lighting directions of each of the 5 spheres

    @param center   of lighting, has a depth as well as x, y
    @param radius   of sphere

    Implementation detail:
        y = 0 at the top of the image/matrix,
            As is generally the case in MATLAB

Output:
    [x1 y1 z1]
    [x2 y2 z2]
    [x3 y3 z3]
    [x4 y4 z4]
    [x5 y5 z5]

    [1 1 3]
    [2 3 5]
    [6 9 6]
    [1 1 1]
    [2 3 5]

%}
function light_dirs_5x3 = computeLightDirections(center, radius, img_cell)

    % c stands for center
    x_c = center(1);
    y_c = center(2);
    z_c = center(3);
    r   = radius;

    DEBUG = 0;
    [num_imgs, num_fields_per_cell] = size(img_cell);
    light_dirs_5x3                  = zeros(5,3);

    for i=1:num_imgs
        img = img_cell{i};
        if DEBUG
            imshow(img);
        end

        % BEGIN meat of the program
        [maxes_of_each_row, x_indices] = max(img,[],2);
        [max_brightness,    y_max]     = max(maxes_of_each_row,[],1);  
        max_brightness                 = cast(max_brightness, 'double');

        x_max                          = x_indices(y_max);
        x_norm                         = x_max - x_c;
        y_norm                         = y_max - y_c;
        z_norm                         = sqrt(r^2     - (x_norm)^2      - (y_norm)^2);
        mag_vect                       = sqrt(x_norm^2 + y_norm^2 + z_norm^2);

        X = 1;
        Y = 2;
        Z = 3;
        light_dirs_5x3(i,X) = (x_norm * max_brightness) / mag_vect;
        light_dirs_5x3(i,Y) = (y_norm * max_brightness) / mag_vect;
        light_dirs_5x3(i,Z) = (z_norm * max_brightness) / mag_vect;
        % END meat of the program




        if DEBUG
            x_norm
            y_norm
            z_norm
            max_brightness
            mag_vect
            light_dirs_5x3(i,X) = (0.0 + x_norm * max_brightness) / mag_vect
            [x_max, y_max]
        end
    end

