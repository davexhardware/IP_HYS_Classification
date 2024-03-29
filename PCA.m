function [img,reduced_image] = PCA(hcube,principal_components)

reduced_image = hyperpca(hcube,principal_components);

img = squeeze(reduced_image(:,:,1)); % Extracting the first image
imshow(img,[]); % Visualize image

rescalePC = rescale(reduced_image,0,1);

figure
montage(rescalePC,'BorderSize',[10 10],'Size',[1 3]);
title('Principal Component Bands of Data Cube')
end

