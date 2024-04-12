clc
clear

% Caricamento dell'immagine
hcube = imread('Seg_Crop1.tif');
load("testGT.mat")
load("wavelengths.mat")
load("labeled_tree_coordinates.mat")

score = zeros(size(hcube.DataCube,1),size(hcube.DataCube,2),numEndmembers);
for i = 1:numEndmembers
    score(:,:,i) = sam(hcube,endmembers(:,i));
end

labels = convxy(3,:);

% Addestramento della Random Forest
numTrees = 500; % Aumenta il numero di alberi
RFmodel = TreeBagger(numTrees, pixelsTrain, labelsTrain, 'Method', 'classification', 'OOBPrediction', 'on');

% Predici le classi sui dati di test
[idx_rf,scores] = predict(RFmodel, pixelsTest);

% Converti l'array di celle delle previsioni in matrice
idx_rf = cellfun(@str2double, idx_rf);
