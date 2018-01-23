%{
    Focuses the scene to any spot in the image you click


    @param rgb_stack  color images of the scene, each focused to different degrees
    @param depth_map  tells which depth should be focused to at each point

    loops until you click on the right hand side padding
%}
function refocusApp(rgb_stack, depth_map)
    DEBUG = 0;

    RGB                  = 3;
    DELAY                = 1;
    INTERMEDIATE_IMGS    = 1;
    curr_img             = 1;

    % the cast() is for imshow() purposes
    rgb_stack            = cast(rgb_stack, 'uint8');
    [height, length, d]  = size(rgb_stack);
    fig_init             = figure();
    ON_RIGHT             = 2;
    pad_len              = 100;
    padded               = cat(ON_RIGHT, rgb_stack(:,:,((RGB*curr_img)-2):(RGB*curr_img)), ...
                                        cast(zeros(height, pad_len, RGB), 'uint8'));
    imshow(padded);     % show the first image


    havent_clicked_right_side = true;
    while havent_clicked_right_side

        disp('             please choose a point in the scene');
        [x, y] = ginput(1);
        x      = cast(x, 'uint64');
        y      = cast(y, 'uint64');

        if x > length
            havent_clicked_right_side = false;
            % break out of loop if right side is clicked instead of a point in the scene
        end

        if DEBUG
            x
            y
        end

        if havent_clicked_right_side
            next_img = depth_map(y,x);
            if next_img > curr_img
                %  up to next_img
                step =  INTERMEDIATE_IMGS;
            else
                %  down
                step = -INTERMEDIATE_IMGS;
            end

            disp(strcat('refocusing to frame', num2str(next_img), '.jpg'));
            fig = figure();

            %                    \/  step is       1 or -1   depending on whether we want to 
            %                    \/          zoom in or out
            for im = curr_img:  step : next_img
                close(fig);
                fig = figure();
                curr_RGB        = (RGB*im)-2:(RGB*im);
                padded_loop     = cat(ON_RIGHT, rgb_stack(:,:,curr_RGB), ...
                                                cast(zeros(height, pad_len, RGB), 'uint8'));
                imshow(padded_loop);
                pause(DELAY);
            end
            curr_img = next_img;
        end
    end

    % close all figs
    close all













































