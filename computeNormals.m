%{
    Computes surface normals and albedo (coloration) for the vases

    @param light_dirs from the spheres
                        matrix S
    @param img_cell   (same vase, 5 lighting angles)
    @param mask       from vases
%}

function [normals, albedo_img] = ...
computeNormals(light_dirs, img_cell, mask)
    DEBUG = 0;

    [num_imgs, num_fields,per_cell] = size(img_cell);
    [height, length]                = size(img_cell{1});
    three_dimensions_xyz            = 3;
    normals                         = zeros(height, length, three_dimensions_xyz);
    albedo_img                      = zeros(height, length);

    vase_img_1 = img_cell{1};
    vase_img_2 = img_cell{2};
    vase_img_3 = img_cell{3};
    vase_img_4 = img_cell{4};
    vase_img_5 = img_cell{5};

    for y=1:height
        for x=1:length

            % vase
            if mask(y,x)
                % biggest values first
                [in_order, brightest_indices]  = sort([vase_img_1(y,x), vase_img_2(y,x), vase_img_3(y,x), vase_img_4(y,x), vase_img_5(y,x)], 'descend');
                I                              = in_order';
                I                              = cast(I, 'double');
                S_5x3                          = light_dirs(brightest_indices,:,:);

                %{
                    % Key Equation:             (S^T * S)^{-1} * S^T * I
                    normals(y,x,:) = pi/rho * (pinv(S_3x3' * S_3x3) * S_3x3' * I);
                %}
                N                              = pinv(S_5x3' * S_5x3) * S_5x3' * I;
                normals(y,x,:)                 = N / norm(N);
                albedo_img(y,x)                = norm(N);

            % background
            else
                out_at_viewer     = 1;
                normals(y,x,:)    = [0,0,out_at_viewer];
                albedo_img(y,x)   = 0;
            end
        end
    end
 
    if (DEBUG)
        figure();
        imshow(normals);
        figure();
        imshow(albedo_img);
    end




























































