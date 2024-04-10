

function [x_img, y_img] = convert_coordinates(x, y)
    % Original image coordinates
    x_min_orig = 686052;
    x_max_orig = 686736;
    y_min_orig = 4535770;
    y_max_orig = 4536510;

    % Destination image dimensions
    width = 1368;
    height = 1480;

    % Calculate scale factors
    scale_x = width / (x_max_orig - x_min_orig);
    scale_y = height / (y_max_orig - y_min_orig);

    % Map the coordinates
    x_img = round((x - x_min_orig) * scale_x);
    y_img = round((y - y_min_orig) * scale_y);
end
