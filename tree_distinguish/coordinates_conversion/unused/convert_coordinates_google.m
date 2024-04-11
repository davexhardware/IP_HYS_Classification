function [x,y] = convert_coordinates_google(lat,lon)
    load("geo_data.mat")
    height=1480;
    pixelTileSize=256.0;
    radiansToDegreesRatio = pi/ 180.0;
    zoomLevel=17;
    pixelGlobeSize=pixelTileSize*power(2,zoomLevel);
    xPixelToDegreesRatio=pixelGlobeSize/360.0;
    yPixelToDegreesRatio=pixelGlobeSize/(2*pi);
    halfPixelGlobeSize = cast(pixelGlobeSize / 2,"single");  
    pixelGlobeCenter=[halfPixelGlobeSize,halfPixelGlobeSize];
    lonLeft = lowsx(1);
    lonRight = highdx(1);
    latBottom = lowsx(2);
    latTop=highdx(2);
    [left,bottom]=from_coordinates_to_pixel_google(latBottom,lonLeft,pixelGlobeCenter,xPixelToDegreesRatio,yPixelToDegreesRatio,radiansToDegreesRatio);
    %[right,top]=from_coordinates_to_pixel_google(latTop,lonRight,pixelGlobeCenter,xPixelToDegreesRatio,yPixelToDegreesRatio,radiansToDegreesRatio)
    [xc,yc]=from_coordinates_to_pixel_google(lat,lon,pixelGlobeCenter,xPixelToDegreesRatio,yPixelToDegreesRatio,radiansToDegreesRatio);
    x=xc-left;
    y=height-yc-bottom;

end