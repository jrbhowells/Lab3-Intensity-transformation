cc;
f = imread('../assets/bonescan-front.tif');
r = double(f);  % uint8 to double conversion
k = mean2(r);   % Find mean intensity of image. Mean2 works on a 2D matrix
E = 0.9;
s = 1 ./ (1.0 + (k ./ (r + eps)) .^ E); % Output scaled from 0 to 1
g = uint8(255*s); % Cinvert back to 0 to 255
imshowpair(f, g, "montage")