
function [x, y] = convert_coordinates(lat, lon)

    load("geo_data.mat");
    % Original image coordinates
    lonLeft = lowsx(1);
    lonRight = highdx(1);
    lonDelta=lonRight-lonLeft;
    latBottom = lowsx(2);
    latBottomRad=latBottom*pi/180.0;

    % Destination image dimensions
    width = 1368;
    height = 1480;

    % Calculate scale factors
    scaleLon = width / lonDelta;

    % Map the coordinates
    x = (lon-lonLeft)*(scaleLon);
    lat=lat*pi/180;
    worldMapWidth=(scaleLon*360.0)/(2*pi);
    mapOffsetY=(worldMapWidth/2) * (log( ( 1+sin(latBottomRad) ) / ( 1-sin(latBottomRad) ) ));
    mapLatCalc=(worldMapWidth/2) * log( ( 1+sin(lat) ) / ( 1-sin(lat)) );
    y = height-(mapLatCalc  - mapOffsetY);
end
% pixelTileSize=256.0;
% degreesToRadiansRatio = 180.0 / pi;
% radiansToDegreesRatio = pi/ 180.0;
% zoomLevel=17;
% pixelGlobeSize=pixelTileSize*power(2,zoomLevel);
% xPixelToDegreesRatio=pixelGlobeSize/360.0;
% YPixelToDegreesRatio=pixelGlobeSize/(2*pi);
% halfPixelGlobeSize = cast(pixelGlobeSize / 2,"single");  
% pixelGlobeCenter=[halfPixelGlobeSize,halfPixelGlobeSize];