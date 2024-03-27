image_path = 'CROP1_47.tiff';

[image,components] = PCA(image_path,3);

[ndvi, msavi, tsavi] = compute_indices(image_path);

