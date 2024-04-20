%We will now use the masked hypercube generated from the tree filtering to cluster the trees in different categories (unsuperivised algorithms)
clc
clear

%I = geotiffinfo('CROP1_47.tiff');
load("wavelengths.mat")
load("labeled_tree_coordinates_firms.mat")

% Carica l'ipercubo
treecube = hypercube("tree_distinguish\source_cropping\crop_trees.dat","tree_distinguish\source_cropping\crop_trees.hdr");

% Plottaggio delle firme spettrali
figure;
hold on;
for i = 1:size(convxy, 1)
    if(convxy(i,3)==1)
        color="b";
    else
        color="r";
    end
    plot(wavelength, convxy(i,4:50),'Color',color);
end
hold off
% Etichette degli assi
xlabel('Lunghezza d''onda');
ylabel('Valore');
title('Firme spettrali');

% Rimozione della legenda
legend('off');

% Miglioramento della visualizzazione
colormap(jet(size(convxy(:,4:50), 1))); % Usa una mappa di colori diversa per distinguere le linee
grid on; % Aggiunge una griglia per facilitare la lettura
