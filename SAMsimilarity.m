%We will now use the masked hypercube generated from the tree filtering to cluster the trees in different categories (unsuperivised algorithms)
clc
clear

I = geotiffinfo('CROP1_47.tiff');
load("wavelengths.mat")
load("testFirms.mat")

% Carica l'ipercubo
treecube = hypercube("tree_distinguish\source_cropping\crop_trees.dat","tree_distinguish\source_cropping\crop_trees.hdr");

% Plottaggio delle firme spettrali
figure;
hold on;
for i = 1:size(spectralFirms, 1)
    plot(wavelength, spectralFirms(i, :));
end
hold off;

% Etichette degli assi
xlabel('Lunghezza d''onda');
ylabel('Valore');
title('Firme spettrali');

% Rimozione della legenda
legend('off');

% Miglioramento della visualizzazione
colormap(jet(size(spectralFirms, 1))); % Usa una mappa di colori diversa per distinguere le linee
grid on; % Aggiunge una griglia per facilitare la lettura
