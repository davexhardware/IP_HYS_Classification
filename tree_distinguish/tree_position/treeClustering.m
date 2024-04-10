%We will now use the masked hypercube generated from the tree filtering to cluster the trees in different categories (unsuperivised algorithms)
% I = geotiffinfo('CROP1_47.tiff');
treecube=hypercube("tree_distinguish\source_cropping\crop_trees.dat","tree_distinguish\source_cropping\crop_trees.hdr");
image=treecube.DataCube;
starting_cluster = 4;
end_cluster = 7;

% Create the directory if it doesn't exist
if ~exist('./Results/kmedoids', 'dir')
    mkdir('./Results/kmedoids');
end
pixels = reshape(image, [], size(image,3));
opts = statset('Display','final','MaxIter',100);

% Loop over the number of clusters
for i = starting_cluster:end_cluster
    % Run imsegkmeans
    %[L,centers] = imsegkmeans(treecube.DataCube, i);
    %imwrite(L, jet(cluster_range(i)), ['./Results/imgkmeansResults/k_meanstrees', num2str(cluster_range(i)), '.png']);

    %run kmedoids
    [idx,centers] = kmedoids(pixels,i,'Options',opts);
    
    % Obtaining image's sizes
    [rows, cols, ~] = size(image);

    % Save the figure
    imwrite(reshape(idx, [rows, cols]), jet(i), ['./Results/kmedoids/kmedoids_trees', num2str(i), '.png']);
end
