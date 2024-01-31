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

Examine the image data store in the matrix *_'f'_*:

```
f(3,10)             % print the intensity of pixel(3,10)
imshow(f(1:241,:))  % display only to top half of the image
```
Indexing of matrix in Matlab is (row, column).  You use *_':'_* to slice the data.  (1:241, :) means rows 1 to 241, and all coloumns.

**Test yourself**: Now, display the right half of the image. Capture it for your logbook.

### Negative image

To compute the negative image and display both original and the negative image side-by-side, do this:

```
g = imadjust(f, [0 1], [1 0])
figure                          % open a new figure window
imshowpair(f, g, 'montage')
```
