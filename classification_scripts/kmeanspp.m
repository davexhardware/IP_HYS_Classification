clc
clear

% Loading image
image_path = 'CROP1_47.tiff';
image = imread(image_path);

% Calculating PCA
[image,components] = PCA(image,5);

% Define the range of clusters
cluster_range = 4:7;

% Create the directory if it doesn't exist
if ~exist('./Results/kmeans++', 'dir')
    mkdir('./Results/kmeans++');
end

% Reshaping image
pixels = reshape(image, [], size(image, 3));

% Set options
opts = statset('Display','final','MaxIter',100000, 'TolFun',1e-6);

% UNCOMMENT THIS IF YOU NEED KMEANS
%opts = statset('Display','final','MaxIter',10000);

% Loop over the number of clusters
for num_clusters = cluster_range
    tic
    % Run k-means++ with 'plus' option
    [idx, centers] = kmeans(pixels, num_clusters, 'Start', 'plus', 'Options', opts);

    %Run k-means with 'plus' option UNCOMMENT THIS IF YOU NEED KMEANS
    %[idx, centers] = kmeans(pixels, num_clusters, 'Options', opts); 

    % Obtaining image's sizes
    [rows, cols, ~] = size(image);

    toc

    % Save the figure
    %imwrite(reshape(idx, [rows, cols]), jet(num_clusters), ['./Results/kmeans++/kmeans_', num2str(num_clusters), '.png']);
end   
%% 

L = reshape(idx, [rows, cols]);

cmp = [ 0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0;];
figure; 
imagesc( L );
colormap( cmp ); 
axis off;
axis image;
