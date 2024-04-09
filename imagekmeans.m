clc
clear

% Loading image
image_path = 'CROP1_47.tiff';
hcube = imread(image_path);

% Define the range of clusters
cluster_range = 4:7;
num_clusters = length(cluster_range);

% Create the directory if it doesn't exist
if ~exist('./Results/imgkmeansResults', 'dir')
    mkdir('./Results/imgkmeansResults');
end

% Loop over the number of clusters
for i = 1:num_clusters
    % Run imsegkmeans
    [L,centers] = imsegkmeans(hcube, cluster_range(i));
    
    % Save the segmented image as an image
    imwrite(L, jet(cluster_range(i)), ['./Results/imgkmeansResults/k', num2str(cluster_range(i)), '.png']);
end
