# Lab 3 - Intensity Transformation

# Task 1 - Contrast Enhancement

We can read an image in to MATLAB, and extract the minimum and maximum intensity values from it.

```matlab
f = imread('assets/breastXray.tif');
[fmin, fmax] = bounds(f(:))
```

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled.png)

As we can see, intensities are stored as uint8s, i.e. they can take any value 0-255.

### Displaying right half of image:

```matlab
imshow(f(:, 241:end))
```

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%201.png)

### Inverting Image:

Using `imadjust()` we can invert the image: the first `[0 1]` maps the inputs to the full range (i.e. so that min. intensity is 0 and max. intensity is 255). The `[1 0]` maps the minimum value onto thw maximum value, and the max. onto the min. (so 0 becomes 255 and 255 becomes 0).

```matlab
g1 = imadjust(f, [0 1], [1 0]);
figure
imshowpair(f, g1, 'montage')
```

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%202.png)

### Gamma Correction:

```matlab
g2 = imadjust(f, [0.5 0.75], [0 1]);
g3 = imadjust(f, [ ], [ ], 2);
figure
montage({g2,g3})
```

In the first (`g2`) line above, we map intensity to be from 0.5 to 0.75 of original. 0-0.5 gets compressed to 0 and 0.75-1 gets compressed to 1

`g3` applies a gamma correction at gamma = 2.

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%203.png)

We can see that the `g2` mapping method removes data - large chunks of the image are black or white. If we don’t want this, the gamma `g3` correction preserves more data, but still biases towards lighter areas.

# Task 2 - Contrast Stretching

We can also use contrast stretching to extract more information from the image.

![stretch.jpg](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/stretch.jpg)

$$
s = T(r) = {1 \over 1 + (k/r)^E}
$$

We can apply the above function to the image in MATLAB:

```matlab
f = imread('../assets/bonescan-front.tif');
r = double(f);  % uint8 to double conversion
k = mean2(r);   % Find mean intensity of image. Mean2 works on a 2D matrix
E = 0.9;
s = 1 ./ (1.0 + (k ./ (r + eps)) .^ E); % Output scaled from 0 to 1
g = uint8(255*s); % Cinvert back to 0 to 255
imshowpair(f, g, "montage")
```

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%204.png)

This function is essentially expanding the centre of the intensity scale of the image, without actually removing data at the edges - it is compressing it, but not into a single value. It allows us to thee the body of the person in the image, not just their bone structure.

# **Task 3 - Contrast Enhancement using Histogram**

MATLAB has a builtin `imhist()` for plotting a histogram from an image:

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%205.png)

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%206.png)

We can see that the intensity of this particular image is compressed into an intensity range of ~75~140, which means we can easily enhance the contrast using `imadjust()`

```matlab
f=imread('../assets/pollen.tif');
g=imadjust(f,[0.3 0.55]);
montage({f, g})
figure
subplot(1,2,1)
imhist(f)
subplot(1,2,2)
imhist(g)
```

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%207.png)

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%208.png)

We can see that the new histogram is a great improvement on the old one.

### PDF & CDF Histograms

A PDF is simply a normalised histogram, while a CDF is a cumulative distribution function - we sum the histogram as we go. We can compute the PDF by normalising:`g_pdf = imhist(g) ./ numel(g);` and the CDF by using the `cumsum()` function on the `g_pdf`. We can plot this:

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%209.png)

Histogram equalisation uses the CDF as the function applied to each pixel. To do this, we first need to scale the cumulative plot so that it has 256 values from 0 to 1:

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2010.png)

```matlab
plot(linspace(0, 1, 256), g_cdf) % Plot from 0 to 1
axis([0 1 0 1]) % Limit axes 0 to 1
set(gca, 'xtick', 0:0.2:1) % Set axes ticks to be spaced by 0.2
set(gca, 'ytick', 0:0.2:1)
xlabel('Input intensity values', 'fontsize', 9) % Labels
ylabel('Output intensity values', 'fontsize', 9)
title('Transformation function', 'fontsize', 12)
```

### A builtin

We can also use the MATLAB builtin `histeq()` to calculate the correct CDF:

```matlab
h = histeq(g,256);
```

We can plot this new image `h` against the original `f` and intermediate `g`.

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2011.png)

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2012.png)

# **Task 4 - Noise reduction with lowpass filter**

We can use lowpass filtering to remove noise: here, we take a noisy image of a PCB and apply an average filter, and apply a gaussian blur - we can see that the average filter achieves more blurring over it’s 9x9 window than the Gaussian does over a 7x7 window.

We first create the average filter `w_box` over a 9x9 window, and then the Gaussian `w_gauss` over 7x7. We can then apply these to the image using `imfilter()`.

```matlab
w_box = fspecial('average', [9 9]);
w_gauss = fspecial('Gaussian', [7 7], 1);
g_box = imfilter(f, w_box, 0);
g_gauss = imfilter(f, w_gauss, 0);

subplot(1,3,1)
imshow(f)
subplot(1,3,2)
imshow(g_box)
subplot(1,3,3)
imshow(g_gauss)
```

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2013.png)

Changing the sigma parameter in the gaussian filter produces different levels of blur:

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2014.png)

The higher sigma we choose, the more pronounced the blurring - and the more effective the de-noising.

# **Task 5 - Median Filtering**

We can actually preserve sharpness in the image by using a *median* filter to perform the de-noising, with the MATLAB builtin `medfilt()` on a 7x7 window.

```matlab
g_median = medfilt2(f, [7 7], 'zero');
```

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2015.png)

As can be seen, the de-noising now doesn’t remove the detail from the image - the edges are still sharp!

# **Task 6 - Sharpening the image with Laplacian, Sobel and Unsharp filters**

```matlab
cc;
f = imread('../assets/moon.tif');

%% Laplacian Filtering
r = double(f);
w_lap = fspecial('laplacian', 0.5);
g_lap = uint8(rescale(imfilter(r, w_lap))*255);

%% Unsharp
w_gauss = fspecial('Gaussian', [7 7], 0.5);
g_gauss = imfilter(f, w_gauss, 0);

g_mask = f - g_gauss;
g_unsharp = f + g_mask;

%% Sobel
w_sob = fspecial('sobel');
g_sob = imfilter(f, w_sob);

g_sob_2 = f + g_sob;

%% Plots
subplot(2,2,1)
imshow(f)
title('Original')
subplot(2,2,2)
imshow(g_lap)
title('Normalised Laplacian')
subplot(2,2,3)
imshow(g_unsharp)
title('Unsharped')
subplot(2,2,4)
imshow(g_sob_2)
title('Sobel')
```

Here, subplots are used as they allow labelling of the plots - even though it puts them further apart.

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2016.png)

Here we apply a Laplacian filter to extract the edges, and then normalise it to be 0-1. We can see all the edges of the craters - but it’s not a realistic image.

Unsharp blurs the image and uses it to create an edge mask, and then adds that to the original - so we can now see the edges better - and Sobel uses similar logic to emphasise the edges further - essentially using a derivative of a 3x3 kernel centred on the current pixel.

# Task 7

## Tree and Lake

Three methods were tried - of these, applying a histagram filter (on the right) proved to be the most effective.

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2017.png)

## Circles

First, the contrast was stretched by removing intensities 0-0.5 and rescaling, and a Gaussian filter sigma = 0.5 was applied to brighten the image. Then, the Sobel filter builtin in MATLAB was applied - this is designed to detect horizontal edges, hence why the top and bottom half of pbjects appear differently on the filter.

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2018.png)

## Office

A colour image of an office. First, a histogram filter was applied to the image to increase contrast. Then a gamma correction could be applied (to all three channels - correcting one channel was tried but did not help). Finally median filter denoising was tried - this lost some clarity, but did reduce the noise in the image slightly.

![Untitled](Lab%203%20-%20Intensity%20Transformation%201091615858d146daac14e7278d647fd3/Untitled%2019.png)