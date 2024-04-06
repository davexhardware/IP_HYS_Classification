function [idx] = kmeans_calculation(image,num_clusters)

% Reshaping image
pixels = reshape(image, [], size(image, num_clusters));

% Set options
opts = statset('Display','final','MaxIter',50000, 'TolFun',1e-6);

% Run k-means++ with 'plus' option
[idx, ~] = kmeans(pixels, num_clusters, 'Start', 'plus', 'Options', opts);

% Obtaining image's sizes
[rows, cols, ~] = size(image);

idx = reshape(idx, [rows, cols]);

end

