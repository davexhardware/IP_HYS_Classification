function [reduced_image] = PCA(path,principal_components)

hcube = imread(path);

reduced_image = hyperpca(hcube,principal_components);

img = squeeze(reduced_image(:,:,1)); % Extracting the first image
imshow(img,[]); % Visualize image
end

