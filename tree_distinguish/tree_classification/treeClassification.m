clc
clear

% Caricamento dell'immagine
load("wavelengths.mat")
load("labeled_tree_coordinates_firms.mat")
%%
labels = convxy(:,3);

coords = convxy(:,1:2);

rows=81;
% Reshaping of image

image=convxy(:,4:50);

% Number of clusters
k = 2;

% Non classificare i valori 0
%image_no_zero = image(any(image~=0,2),:);

gmm = fitgmdist(image, k,"CovarianceType","full","RegularizationValue",0.0001);

gmm_labels = cluster(gmm, image);

% Inserimento delle etichette nel luogo appropriato
clustered_image = gmm_labels-1.0;
%%
accuracy=sum(convxy(:,3)==clustered_image,'all')/numel(clustered_image)
accuracyLeccino=sum((convxy(:,3)==0) & (clustered_image==0))/sum(convxy(:,3)==0)
accuracyOgliarola=sum((convxy(:,3)==1) & (clustered_image==1))/sum(convxy(:,3)==1)
%%
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