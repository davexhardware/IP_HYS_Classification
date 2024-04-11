function [x,y] = convert_merc_coordinates(lat,lng,mapWidth,mapHeight)
    x=(lng+180)*(mapWidth/360);
    latRad=lat*pi/180;
    mercN=log( tan(pi/4)+(latRad/2) );
    y=(mapHeight/2)-(mapWidth*mercN/(2*pi));
end