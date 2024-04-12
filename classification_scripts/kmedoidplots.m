clc
clear

% Loading image
image_path = 'CROP1_47.tiff';
image = imread(image_path);

% Calculating PCA
%[image,components] = PCA(hcube,5);

% Create the directory if it doesn't exist
if ~exist('./Results/kmedoids', 'dir')
    mkdir('./Results/kmedoids');
end

% Reshaping image
pixels = reshape(image, [], size(image, 3));

% Set options
opts = statset('Display','final','MaxIter',100);

% Define the range of cluster numbers
cluster_range = 4:7;

for num_clusters = cluster_range

    tic

    % Run k-medoids
    [idx,centers] = kmedoids(pixels,num_clusters,'Options',opts);

    % Obtaining image's sizes
    [rows, cols, ~] = size(image);

    toc

    % Save the figure
    imwrite(reshape(idx, [rows, cols]), jet(num_clusters), ['./Results/kmedoids/kmedoids_', num2str(num_clusters), '.png']);
end
