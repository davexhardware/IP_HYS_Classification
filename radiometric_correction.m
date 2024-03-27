function [corrected_img] = radiometric_correction(path, atmospheric_correction)
    % Leggi l'immagine TIFF
    hcube = imread(path);
    
    % Normalize values [0,1]
    hcube = double(hcube)/255;
    
    % Correction
    corrected_img = hcube - atmospheric_correction;
    
    % Value needs to be boolean 
    corrected_img(corrected_img < 0) = 0;
    corrected_img(corrected_img > 1) = 1;
end
