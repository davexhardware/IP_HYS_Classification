% Load the image
load("wavelengths.mat")
image_path = 'CROP1_47.tiff';
hcube = imread(image_path);

% Calculating PCA
[image,components] = PCA(hcube,3);

% Index Calculation
%[ndvi, msavi, tsavi] = compute_indices(hcube);

% Trying classification
classified_image = kmeans_calculation(image, 3);
