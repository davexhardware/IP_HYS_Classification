clc
clear

% Caricamento dell'immagine
hcube = hypercube('crop_trees.dat', 'crop_trees.hdr');
load("wavelengths.mat")
load("labeled_tree_coordinates.mat")

labels = convxy(:,3);

coords = convxy(:,1:2);

[rows, columns, bands] = size(hcube.DataCube);

% Reshaping of image
image = reshape(hcube.DataCube, [rows*columns, bands]);

% Number of clusters
k = 2;

% Non classificare i valori 0
image_no_zero = image(any(image~=0,2),:);

gmm = fitgmdist(image_no_zero, k);

gmm_labels = cluster(gmm, image_no_zero);

% Creazione di un'immagine vuota
clustered_image = zeros(rows*columns,1);

% Inserimento delle etichette nel luogo appropriato
clustered_image(any(image~=0,2)) = gmm_labels;

clustered_image = reshape(clustered_image, [rows, columns]);

% Creazione del plot
figure;
imshow(clustered_image,[]);
colormap("jet");
colorbar;
title('GMM');

% hold on;
% 
% markerSize = 10;
% 
% for i = 1:length(labels)
%     if labels(i) == 0
%         plot(coords(i,1), coords(i,2), 'go', 'MarkerSize', markerSize);
%     else
%         plot(coords(i,1), coords(i,2), 'wx', 'MarkerSize', markerSize);
%     end
% end
% 
% hold off; 