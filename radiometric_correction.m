function [corrected_img] = radiometric_correction(img, atmospheric_correction)
    
    % Normalize values [0,1]
    img = double(img)/255;
    
    % Correction
    corrected_img = img - atmospheric_correction;
    
    % Value needs to be boolean 
    corrected_img(corrected_img < 0) = 0;
    corrected_img(corrected_img > 1) = 1;
end

function [corrected_hcube] = apply_radiometric_correction(hcube, atmospheric_correction, wavelength)

    % Supponiamo che 'hcube' sia un ipercubo 3D dove la terza dimensione corrisponde alle lunghezze d'onda
    % e 'atmospheric_correction' sia un array 1D delle stesse dimensioni dell'array 'wavelength'.

    corrected_hcube = hcube;

    for i = 1:length(wavelength)
        corrected_hcube(:,:,i) = radiometric_correction(hcube(:,:,i), atmospheric_correction(i));
    end
end