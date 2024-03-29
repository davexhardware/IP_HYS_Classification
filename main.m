% Load the image
image_path = 'CROP1_47.tiff';
hcube = imread(image_path);

% Calculating PCA
[image,components] = PCA(hcube,3);

% Index Calculation
%[ndvi, msavi, tsavi] = compute_indices(hcube);

% Trying classification
classified_image = kmeans(image, 3);

figure;
imshow(classified_image, []);
colormap(jet(3));
colorbar;
title('K-means++ clustering results');