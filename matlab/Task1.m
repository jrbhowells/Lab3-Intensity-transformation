cc;
imfinfo('../assets/breastXray.tif')
f = imread('../assets/breastXray.tif');

g1 = imadjust(f, [0 1], [1 0]);
figure
imshowpair(f, g1, 'montage')

g2 = imadjust(f, [0.5 0.75], [0 1]); % Map intensity to be from 0.5 to 0.75 of original. 0-0.5 gets compressed to 0 and 0.75-1 gets compressed to 1
g3 = imadjust(f, [ ], [ ], 2); % Apply a gamma correction at gamma = 2
figure
montage({g2,g3})