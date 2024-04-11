function [corrected_img] = radiometric_correction(img, atmospheric_correction)
    
    % Normalize values [0,1]
    img = double(img)/255;
    
    % Correction
    corrected_img = img - atmospheric_correction;
    
    % Value needs to be boolean 
    corrected_img(corrected_img < 0) = 0;
    corrected_img(corrected_img > 1) = 1;
end
