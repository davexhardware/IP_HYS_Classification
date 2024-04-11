% Load the image
load("wavelengths.mat")
image_path = 'CROP1_47.tiff';
hcube = imread(image_path);

% Calculating PCA
[image,components] = PCA(hcube,3);

% Index Calculation
%[ndvi, msavi, tsavi] = compute_indices(hcube);

% Trying classification
classified_image = kmeans_calculation(image, 3);

corrected_image = apply_radiometric_correction(hcube, atmospheric_correction, wavelength);

function [corrected_hcube] = apply_radiometric_correction(hcube, atmospheric_correction, wavelength)

    % Supponiamo che 'hcube' sia un ipercubo 3D dove la terza dimensione corrisponde alle lunghezze d'onda
    % e 'atmospheric_correction' sia un array 1D delle stesse dimensioni dell'array 'wavelength'.

    corrected_hcube = hcube;

    for i = 1:length(wavelength)
        corrected_hcube(:,:,i) = radiometric_correction(hcube(:,:,i), atmospheric_correction(i));
    end
end