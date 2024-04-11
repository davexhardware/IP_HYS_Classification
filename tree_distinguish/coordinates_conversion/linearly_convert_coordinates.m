function [X,Y] = linearly_convert_coordinates(x,y)
    load('geo_data.mat')
    x_min_orig = I.BoundingBox(1,1);
    x_max_orig = I.BoundingBox(2,1);
    y_min_orig = I.BoundingBox(1,2);
    y_max_orig = I.BoundingBox(2,2);
%     x_min_orig = lowsx(1);
%     x_max_orig = highdx(1);
%     y_min_orig = lowsx(2);
%     y_max_orig =highdx(2);

    % Destination image dimensions
    width = 1368;
    height = 1480;

    % Calculate scale factors
    scale_x = width / (x_max_orig - x_min_orig);
    scale_y = height / (y_max_orig - y_min_orig);

    % Map the coordinates
    X = round((x - x_min_orig) * scale_x);
    Y = height-round((y - y_min_orig) * scale_y);
end