function [x,y] = from_coordinates_to_pixel_google(lat,lng,pixelGlobeCenter,xPixelToDeg,yPixelToRad,radiansToDegrees)
    x=round(pixelGlobeCenter(1)+ (lng)*xPixelToDeg );
    f=min(max(sin(lat*radiansToDegrees),-0.9999),0.9999); % limit the sin between -1 and 1
    y=round(pixelGlobeCenter(2)+ 0.5*log((1+f)/(1-f)) * -yPixelToRad);
end