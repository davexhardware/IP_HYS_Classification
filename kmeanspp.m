clc
clear

% Loading image
image_path = 'CROP1_47.tiff';
hcube = imread(image_path);

% Calculating PCA
[image,components] = PCA(hcube,5);

% Define the range of clusters
cluster_range = 4:7;

% Create the directory if it doesn't exist
if ~exist('./Results/kmeans++', 'dir')
    mkdir('./Results/kmeans++');
end

% Reshaping image
pixels = reshape(image, [], size(image, 3));

% Set options
opts = statset('Display','final','MaxIter',50000, 'TolFun',1e-6);

% Loop over the number of clusters
for num_clusters = cluster_range
    % Run k-means++ with 'plus' option
    [idx, centers] = kmeans(pixels, num_clusters, 'Start', 'plus', 'Options', opts);

    % Obtaining image's sizes
    [rows, cols, ~] = size(image);

    % Save the figure
    imwrite(reshape(idx, [rows, cols]), jet(num_clusters), ['./Results/kmeans++/kmeans_', num2str(num_clusters), '.png']);
end
    