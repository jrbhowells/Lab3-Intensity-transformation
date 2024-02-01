%% Task 7. Run one section at a time.

%% Lake and Tree
cc;
f = imread('../assets/lake&tree.png');
% imshow(f)

% Apply gamma-correction at gamma = 0.5
g1 = imadjust(f, [ ], [ ], 0.5);

% Apply a contrast-stretching transformation.
% Not plotted because it's the worst performer of these.
r = double(f);
k = mean2(r);
E = 0.99;
s = 1 ./ (1.0 + (k ./ (r + eps)) .^ E);
g2 = uint8(255*s);

% Apply a histogram
g3 = histeq(f,256);

montage({f, g1, g3})

%% Circles
cc;
f = imread('../assets/circles.tif');
% imshow(f)

% Window the image
g1 = imadjust(f, [0.5 1], [], 0.5);

% Sobel filter
w = fspecial('sobel');
g2 = imfilter(g1, w);
g3 = f + g2;

montage({f, g1, g2, g3})

%% Office
cc;
f = imread('../assets/office.jpg');
% imshow(f)

% Apply a histogram
g1 = histeq(f, 256);

% Apply gamma-correction at gamma = 0.5
g2 = imadjust(g1, [ ], [ ], 0.75);

% Boost contrast in greens. Ineffective so ignored
gX = g2;
gX(:,:,2) = imadjust(g2(:,:,2), [ ], [ ], 0.75);

% Denoise
g3 = g2;
g3(:,:,1) = medfilt2(g2(:,:,1), [5 5], 'zero');
g3(:,:,2) = medfilt2(g2(:,:,2), [5 5], 'zero');
g3(:,:,2) = medfilt2(g2(:,:,2), [5 5], 'zero');

montage({f, g1, g2, g3})

