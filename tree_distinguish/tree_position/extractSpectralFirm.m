clc
clear

path = "spectralFirms.xlsx";
endRow = 82;
width=1368;
height=1480;
% Reading datas about Spectral firms (Nx47, double)
range = strcat('F2:AZ', num2str(endRow));
spectralFirms = readmatrix(path, 'Sheet', 'Sheet1', 'Range', range);
load("geo_data.mat")
% Reading datas about cordinates (Nx2, double)
range = strcat('B2:C', num2str(endRow));
coordinates = readmatrix(path, 'Sheet', 'Sheet1', 'Range', range);
convxy=zeros(size(coordinates));
% convxym=zeros(size(coordinates));
% convxylin=zeros(size(coordinates));
% pixels=power(2,17);
load("geo_data.mat")
proj = I.SpatialRef.ProjectedCRS;
proj.GeographicCRS.Name
% [left,bottom]=convert_merc_coordinates(lowsx(2),lowsx(1),pixels,pixels);
% [right,upper]=convert_merc_coordinates(highdx(2),highdx(1),pixels,pixels);

for i=(1:size(coordinates,1))
    if(coordinates(i,1)<lowsx(2) || coordinates(i,2)<lowsx(1) || coordinates(i,1)>highdx(2) || coordinates(i,2)>highdx(1))
        coordinates(i,:) %% WE HAVE A TREE THAT IS NOT IN THE RANGE OF COORDINATES OF THE MAP CROP
        i
        continue
    end
    [convxy(i,1),convxy(i,2)]=projfwd(proj,coordinates(i,1),coordinates(i,2));
    [convxy(i,1),convxy(i,2)]=linearly_convert_coordinates(convxy(i,1),convxy(i,2));
%     [convxy(i,1),convxy(i,2)]=convert_coordinates(coordinates(i,1),coordinates(i,2));
%     [convxylin(i,1),convxylin(i,2)]=linearly_convert_coordinates(coordinates(i,1),coordinates(i,2));
%     [convxym(i,1),convxym(i,2)]=convert_merc_coordinates(coordinates(i,1),coordinates(i,2),pixels,pixels);
%     convxym(i,1)=(convxym(i,1)-left)*(width/(right-left));
%     convxym(i,2)=(convxym(i,2)-upper)*(height/(bottom-upper));
end
figure
load('wavelengths.mat')
hcube=hypercube('CROP1_47.tiff',wavelength);
rgbImg=colorize(hcube,'Method','rgb','ContrastStretching',true);
imshow(rgbImg)
axis on
hold on;
for i=(1:size(coordinates,1))
    plot(convxy(i,1),convxy(i,2),'r+','MarkerSize',5,'LineWidth',1)
%     plot(convxylin(i,1),convxylin(i,2),'m+','MarkerSize',5,'LineWidth',2)
%     plot(convxym(i,1),convxym(i,2),'b+','MarkerSize',5,'LineWidth',1)
end
% Reading datas about labels (Nx1, String cells)
range = strcat('D2:D', num2str(endRow));
labels = readcell(path, 'Sheet', 'Sheet1', 'Range', range);
