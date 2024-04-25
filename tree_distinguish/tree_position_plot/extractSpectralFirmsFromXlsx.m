clc
clear

path = "spectralFirms.xlsx";
endRow = 82;
% Reading datas about Spectral firms (Nx47, double)
range = strcat('F2:AZ', num2str(endRow));
spectralFirms = readmatrix(path, 'Sheet', 'Sheet1', 'Range', range);
% Reading datas about cordinates (Nx2, double)
range = strcat('B2:C', num2str(endRow));
coordinates = readmatrix(path, 'Sheet', 'Sheet1', 'Range', range);
% Initialize ...
convxy=zeros(size(coordinates,1),50);
% ....
load("geo_data.mat")
proj = I.SpatialRef.ProjectedCRS;
proj.GeographicCRS.Name
% ....
for i=(1:size(coordinates,1))
    [convxy(i,1),convxy(i,2)]=projfwd(proj,coordinates(i,1),coordinates(i,2));
    [convxy(i,1),convxy(i,2)]=linearly_convert_coordinates(convxy(i,1),convxy(i,2));

end
range = strcat('D2:D', num2str(endRow));
labels = readcell(path, 'Sheet', 'Sheet1', 'Range', range);
for i=(1:size(coordinates,1))
    convxy(i,4:50)=spectralFirms(i,:);
    convxy(i,3)= labels(i)=="Ogliarola barese";
end
%%
% ...
figure
load('wavelengths.mat')
hcube=hypercube('CROP1_47.tiff',wavelength);
rgbImg=colorize(hcube,'Method','rgb','ContrastStretching',true);
imshow(rgbImg)
hold on;
axis off;
%....
for i=(1:size(coordinates,1))
    if(convxy(i,3)==0) %LECCINO
        h(1)=plot(convxy(i,1),convxy(i,2),'r+','MarkerSize',5,'LineWidth',1,'DisplayName','Leccino');
    else % Ogliarola barese
        h(2)=plot(convxy(i,1),convxy(i,2),'b+','MarkerSize',5,'LineWidth',1,'DisplayName','Ogliarola');
    end
end

legend(h,'Leccino','Ogliarola Barese')
