
Challenge 1 part a.
    I took the average of the major and minor axes because the 'spheres' were not perfectly circular in the pictures


Challenge 1 part b.
    Brightest spot is direction of light source:
        It is safe to assume this because the sphere is Lambertian.  Therefore, the closest spot of the sphere to the light source will be exposed to the most photons and therefore reflect in all directions (illuminance falls as r^2 so the light will be most intense closest to the light source and less and less intense as we consider points on the sphere farther from the light source).  Moreover, we know the light reflects off the brightest spot in all directions, not just the direction opposite the source, as a mirror would

Challenge 1 part c.
    The 'ANY_PIX' variable is kind of hack-y, but I needed to avoid picking up only the 0 values in the mask

Challenge 1 part d.
   1. Sorted (biggest values first)
   2. Calculated pseudoinverse and used to get albedos and normals
    It works!

Challenge 2 part a.
    loadFocalStack() loads the 25 rgb images
    In generateIndexMap(), I made things work very quickly by using the technique Prof. Nayar showed us (cumulative sums of the focus_measure values.
        I used del2() because it did a lot of the work for me
        Gaussian filter worked fairly well 
        I had to handle edge cases and make sure everything worked in those circumstances as well (when the window is smaller than normal, etc.

Challenge 2 part b.
    refocuses until the user clicks the right side of the screen

Thanks for your time!
Cheers,
Nathan

