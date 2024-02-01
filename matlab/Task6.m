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