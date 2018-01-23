%{
    output stacks are matrices, not cells

    Overview:
        1. Compute focus measure for each pixel in the image
        2. Find layer where this pixel is best focused
%}

function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)
    DEBUG = 0;

    % change to stack dir
    cd (focal_stack_dir)

    [height, len, RGB] = size(imread('frame1.jpg'));
    NUM_FRAMES = 25; % in an IRL application, this would be adaptive to the directory rather than hardcoded, but here we don't care

    rgb_stack  = zeros(height,len,RGB * NUM_FRAMES);
    gray_stack = cast(zeros(height,len,      NUM_FRAMES),'uint8');

    for i=1:NUM_FRAMES
        img_end                                = RGB*i;
        img                                    = imread(['frame' num2str(i) '.jpg']);
        rgb_stack(:,:,(img_end - 2):(img_end)) = img;
        gray_stack(:,:,i)                      = rgb2gray(img);



        % show grayscale images for each frame
        if DEBUG
            fig = figure();
            imshow(rgb2gray(img));
            pause(1);
            close(fig);
        end
    end

    % return to prev directory: no side effects
    cd ..

