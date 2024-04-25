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

% Inizializzazione delle variabili
bestRegValue = 0;
bestAvgAccuracy = 0;
bestAccuracy1=1;
bestAccuracy0=0;
bestDiffRegValue=0;
regValues = logspace(-10, 1, 1000);  % Valori di regolarizzazione
numRuns = 100;  % Numero di esecuzioni per ogni valore di regolarizzazione
k = 2;  % Numero di cluster
maxIter = 1000;  % Numero massimo di iterazioni

accuracyArray = zeros(numRuns, length(regValues),3);
stdArray = zeros(length(regValues),3);
rng(4)

for regIndex = 1:length(regValues)
    reg = regValues(regIndex);
    
    for i = 1:numRuns
        options = statset('MaxIter', maxIter);
        gmm = fitgmdist(image, k, "CovarianceType", "full", "RegularizationValue", reg, 'Options', options);
        gmm_labels = cluster(gmm, image);
        clustered_image = gmm_labels - 1.0;
        
        % Calcolo dell'accuratezza
        accuracy = sum(convxy(:,3) == clustered_image, 'all') / numel(clustered_image);
        accuracy1=sum((convxy(:,3)==1) & (clustered_image==1)) /sum(convxy(:,3)==1);
        accuracy0=sum((convxy(:,3)==0) & (clustered_image==0)) /sum(convxy(:,3)==0);
        accuracyArray(i, regIndex,:) = [accuracy,accuracy1,accuracy0];
    end
    
    avgAccuracy = mean(accuracyArray(:, regIndex,1));
    avgAccuracy1=mean(accuracyArray(:, regIndex,2)); 
    avgAccuracy0=mean(accuracyArray(:, regIndex,3));
    stdArray(regIndex, :) = std(accuracyArray(:, regIndex, :));
    
    if avgAccuracy > bestAvgAccuracy
        bestAvgAccuracy = avgAccuracy;
        bestRegValue = reg;
    end
    if abs(avgAccuracy1-avgAccuracy0)<abs(bestAccuracy1-bestAccuracy0)
        bestAccuracy0=avgAccuracy0;
        bestAccuracy1=avgAccuracy1;
        bestDiffRegValue=reg;
    end
end
%%
accuracyArray1=accuracyArray(:,:,2);
accuracyArray0=accuracyArray(:,:,3);    
accuracyArray=accuracyArray(:,:,1);


fprintf('Il miglior valore di regolarizzazione è: %f\n', bestRegValue);
fprintf('Il miglior valore di regolarizzazione delle differenze è: %f\n', bestDiffRegValue);

%%
% Creazione del plot
% figure;
% imshow(clustered_image,[]);
% colormap("jet");
% colorbar;
% title('GMM');
