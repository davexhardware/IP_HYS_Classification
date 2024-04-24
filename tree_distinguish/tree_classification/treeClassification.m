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
regValues = logspace(0.000001, 1, 100);  % Valori di regolarizzazione
numRuns = 100;  % Numero di esecuzioni per ogni valore di regolarizzazione
k = 5;  % Numero di cluster
maxIter = 1000;  % Numero massimo di iterazioni

% Array per memorizzare le accuratezze
accuracyArray = zeros(numRuns, length(regValues));

% Loop attraverso i valori di regolarizzazione
for regIndex = 1:length(regValues)
    reg = regValues(regIndex);
    
    % Esegui l'algoritmo per un numero specificato di volte
    for i = 1:numRuns
        options = statset('MaxIter', maxIter);
        gmm = fitgmdist(image, k, "CovarianceType", "full", "RegularizationValue", reg, 'Options', options);
        gmm_labels = cluster(gmm, image);
        clustered_image = gmm_labels - 1.0;
        
        % Calcolo dell'accuratezza
        accuracy = sum(convxy(:,3) == clustered_image, 'all') / numel(clustered_image);
        accuracyArray(i, regIndex) = accuracy;
    end
    
    % Calcolo dell'accuratezza media
    avgAccuracy = mean(accuracyArray(:, regIndex));
    
    % Aggiornamento del miglior valore di regolarizzazione e accuratezza
    if avgAccuracy > bestAvgAccuracy
        bestAvgAccuracy = avgAccuracy;
        bestRegValue = reg;
    end
end

% Stampa del miglior valore di regolarizzazione
fprintf('Il miglior valore di regolarizzazione è: %f\n', bestRegValue);

%%
% Creazione del plot
% figure;
% imshow(clustered_image,[]);
% colormap("jet");
% colorbar;
% title('GMM');
