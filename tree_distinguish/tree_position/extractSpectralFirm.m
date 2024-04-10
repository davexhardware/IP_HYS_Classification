clc
clear

path = "spectralFirms.xlsx";
endRow = 84;

% Reading datas about Spectral firms (Nx47, double)
range = strcat('F2:AZ', num2str(endRow));
spectralFirms = readmatrix(path, 'Sheet', 'Sheet1', 'Range', range);

% Reading datas about cordinates (Nx2, double)
range = strcat('B2:C', num2str(endRow));
coordinates = readmatrix(path, 'Sheet', 'Sheet1', 'Range', range);

% Reading datas about labels (Nx1, String cells)
range = strcat('D2:D', num2str(endRow));
labels = readcell(path, 'Sheet', 'Sheet1', 'Range', range);
