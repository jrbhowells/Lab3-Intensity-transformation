# Lab 3 - Intensity Transformation and Spatial Filtering
*_Peter Cheung, version 1.0, 1 Feb 2024_*

This lab session aims to demonstrate the contents of Lectures 4 and 5 with image files processed on Matlab.  The choice of Matlab is driven by their excellent set of functions included in the Image Processing Toolbox.  As Design Engineers, it is more important for you to understand the principles and then use ready-made libraries to perform processing on visual data, then to write low-level code to implement the algorithms.

Clone this repo to your laptop and do all your work using your local copy.

## Task 1: Contrast adjustment with *_function imadjust_*

### Importing an image

Check out the image file *_breastXray.tif_* stored in the assets folder and read this into the matrix *_f_*, and display it:

```
clear all
imfinfo('assets/breastXray.tif')
f = imread('assets/breastXray.tif');
imshow(f)
```
>Note: Make sure you use the semicolon to suppress output. Otherwise, all pixel values will be stream to your display and will take a long time. Use CTRL-C to interrupt the command if you forget.

Check the dimension of f on the right window pane of Matlab. Examine the image data store in the matrix *_'f'_*:

```
f(3,10)             % print the intensity of pixel(3,10)
imshow(f(1:241,:))  % display only to top half of the image
```
Indices of matrix in Matlab is of the format: (row, column).  You can use *_':'_* to *_slice_* the data.  (1:241, :) means only rows 1 to 241, and all coloumns are used.  The default is the entire matrix.

To find the maximum and minimum intensity value of the image, do this:
```
[fmin, fmax] = bounds(f(:)))
```
*_bounds_* returns the maximum and minimum values in the entire image f. The index (:) means every columns. If this is not specified, Matlab will return the max and min values for each column as row vector.

Since the data type for f is uint8, the full intensity range should be [0 255].  Is it close to the full range?

**Test yourself**: Display the right half of the image. Capture it for your logbook.

### Negative image

To compute the negative image and display both original and the negative image side-by-side, do this:

```
g1 = imadjust(f, [0 1], [1 0])
figure                          % open a new figure window
imshowpair(f, g1, 'montage')
```
>The 2nd parameter is in the form of [low_in high_in], where the values are between 0 and 1.  [0 1] means that the input image is to be adjusted to within 1% of the bottom and top pixel values.  

>The 3rd parameter is also in the form of [low_in high_in]. It specifies how the input range is mapped to output range.  So, [1 0] means that the lowest pixel intensity of the input is now mapped to highest pixel intensity at the output and vice versa.  This of course means that all intensities are inverted producing the negative image.

### Gamma correct

Try this:
```
g2 = imadjust(f, [0.5 0.75], [0 1]);
g3 = imadjust(f, [ ], [ ], 2);
figure
imshowpair(g2, g3, 'montage')
```
g2 has the gray scale range between 0.5 and 0.75 expanded to the full range.

g3 uses gamma correct with gamma = 2.0 as shown in the diagram below. [ ] is the same as [0 1] by default.

<p align="center"> <img src="assets/gamma.jpg" /> </p><BR>

This produces a result similar to that of g2 by compressing the low end and expanding the high end of the gray scale.  It however, unlike g2,  retains more of the detail because the intensity now covers the entire gray scale range.

## Task 2: Contrast-stretching transformation

Instead of using the *_imadjust function_*, we will apply the constrast stretching transformation in Lecture 4 slide 4 to improve the contrast of another X-ray image.  The transformation function is as shown here:

<p align="center"> <img src="assets/stretch.jpg" /> </p><BR>

Test equation:

When $a \ne 0$, there are two solutions to $(ax^2 + bx + c = 0)$ and they are 
$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$

