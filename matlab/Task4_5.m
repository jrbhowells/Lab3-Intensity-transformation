cc;
f = imread('../assets/noisyPCB.jpg');

w_box = fspecial('average', [9 9]);
w_gauss = fspecial('Gaussian', [7 7], 1);
g_box = imfilter(f, w_box, 0);
g_gauss = imfilter(f, w_gauss, 0);

%% Subplot Filters
% subplot(1,3,1)
% imshow(f)
% subplot(1,3,2)
% imshow(g_box)
% subplot(1,3,3)
% imshow(g_gauss)

%% Vary Simgas
% w025 = fspecial('Gaussian', [7 7], 0.25);
% w1 = fspecial('Gaussian', [7 7], 1);
% w2 = fspecial('Gaussian', [7 7], 2);
% g025 = imfilter(f, w025, 0);
% g1 = imfilter(f, w1, 0);
% g2 = imfilter(f, w2, 0);
% subplot(1,3,1)
% imshow(g025)
% title('simga = 0.25')
% subplot(1,3,2)
% imshow(g1)
% title('simga = 1')
% subplot(1,3,3)
% imshow(g2)
% title('simga = 2')

g_median = medfilt2(f, [7 7], 'zero');
figure; montage({f, g_median})