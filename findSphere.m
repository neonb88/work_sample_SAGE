%{
    Finds the center and radius of the various spheres from the images

    y indexing is 0 at the top of the image, just as usual in MATLAB
%}
function [center, radius] = findSphere(img)
    RIGHT_OF = 2;

    bw           = im2bw(img);
    center       = regionprops(bw, 'Centroid');
    center       = center.Centroid;
    center       = cat(RIGHT_OF, center, 0.0);               % call the depth (z) of the center 0
    area         = regionprops(bw, 'Area');

    minor_struct = regionprops(bw, 'MinorAxisLength');
    major_struct = regionprops(bw, 'MajorAxisLength');
    minor_len    = minor_struct.MinorAxisLength;
    major_len    = major_struct.MajorAxisLength;
    diameter     = (major_len + minor_len) / 2;            % Diameter oughta be about the same since it's roughly spherical
    radius       = diameter/2;












































