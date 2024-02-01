cc;
f=imread('../assets/pollen.tif');
g=imadjust(f,[0.3 0.55]);
montage({f, g})
figure
subplot(1,2,1)
imhist(f)
subplot(1,2,2)
imhist(g)

g_pdf = imhist(g) ./ numel(g);  % Compute PDF
g_cdf = cumsum(g_pdf);          % Compute CDF
close all
imshow(g);
subplot(1,2,1)
plot(g_pdf)
subplot(1,2,2)
plot(g_cdf)

figure
plot(linspace(0, 1, 256), g_cdf) % Plot from 0 to 1
axis([0 1 0 1]) % Limit axes 0 to 1
set(gca, 'xtick', 0:0.2:1) % Set axes ticks to be spaced by 0.2
set(gca, 'ytick', 0:0.2:1)
xlabel('Input intensity values', 'fontsize', 9) % Labels
ylabel('Output intensity values', 'fontsize', 9)
title('Transformation function', 'fontsize', 12)

h = histeq(g,256);
close all
montage({f, g, h})
figure;
subplot(1,3,1); imhist(f);
subplot(1,3,2); imhist(g);
subplot(1,3,3); imhist(h);