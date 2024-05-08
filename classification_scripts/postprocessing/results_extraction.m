tree_mask=imread("tree_distinguish/source_cropping/Seg_Crop1.tif");

masked_matrix = mask_matrix(classMap,2);

% Inizializza la matrice dei risultati con zeri
result = zeros(size(masked_matrix));

% Imposta i punti a -1 dove masked_matrix è vero e tree_mask è falso
result(masked_matrix & ~tree_mask) = -1;

% Imposta i punti a 1 dove masked_matrix è falso e tree_mask è vero
result(~masked_matrix & tree_mask) = 1;

% Visualizza il risultato come un'immagine in bianco e nero
imshow(result, []);