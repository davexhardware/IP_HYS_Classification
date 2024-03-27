function [ndvi, msavi, tsavi] = compute_indices(path)
    % Reading image
    hcube = imread(path);
    
    % Normalize values [0,1]
    red = double(hcube(:,:,10))/255;
    nir = double(hcube(:,:,30))/255;
    
    % Calculate NDVI
    ndvi = (nir - red) ./ (nir + red);
    
    % Calculate MSAVI
    L = 0.5;  % Regularization factor (need to be recalculated)
    msavi = 0.5 * (2*(nir + 1) - sqrt((2*nir + 1).^2 - 8*(nir - red)));
    
    % Calculate TSAVI
    s = 1;  % Soil line slope
    a = 1;  % Soil line intercept
    X = 0.08;  % Regularization factor (need to be recalculated)
    tsavi = s * (nir - s * red - a) ./ (a * nir + red - a * s + X * (1 + s^2));
    
    indices = {ndvi,msavi,tsavi};

    % Stack the figures to 1x3
    figure
    montage(indices, 'BorderSize', [10 10], 'Size', [1 3]);
end
