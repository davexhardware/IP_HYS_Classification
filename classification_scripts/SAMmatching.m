load("wavelengths.mat")
hcube = hypercube('CROP1_47.tiff',wavelength);

fileroot = matlabshared.supportpkg.getSupportPackageRoot();
addpath(fullfile(fileroot,'toolbox','images','supportpackages','hyperspectral',...
    'hyperdata','ECOSTRESSSpectraFiles'));

filenames = ["soil.vertisol.chromoxerert.none.all.88p475.jhu.becknic.spectrum.txt",...
    "vegetation.tree.olea.africana.vswir.jpl121.jpl.asd.spectrum.txt",...
    "vegetation.grass.unknown.unknown.all.grass.jhu.becknic.spectrum.txt",...
    "soil.mollisol.cryoboroll.none.all.85p4663.jhu.becknic.spectrum.txt",...    
    "manmade.road.pavingasphalt.solid.all.0096uuuasp.jhu.becknic.spectrum.txt" ];
lib = readEcostressSig(filenames);
libsize=size(lib,2);
classNames=[lib.Class];
for i=(1:libsize)
    if ~lib(i).SubClass.ismissing
        classNames(i)=classNames(i)+" "+lib(i).SubClass;
    elseif ~lib(i).Genus.ismissing
        classNames(i)=classNames(i)+" "+lib(i).Genus;
    end
end
figure
hold on
for idx = 1:numel(lib)
    plot(lib(idx).Wavelength,lib(idx).Reflectance,'LineWidth',2)
end
axis tight
box on
title('Pure Spectral Signatures from ECOSTRESS Library')
xlabel('Wavelength (\mum)')
ylabel('Reflectance (%)')
legend(classNames,'Location','northeast')
title(legend,'Class Names')
hold off
scoreMap = spectralMatch(lib,hcube);
figure
montage(scoreMap,'Size',[1 numel(lib)],'BorderSize',10)
title('Score Map Obtained for Each Pure Spectrum','FontSize',14)
colormap(jet);
colorbar
%%
[~,classMap] = min(scoreMap,[],3);
classTable = table((min(classMap):max(classMap))',classNames(2:5)',...
             'VariableNames',{'Classification map value','Matching library signature'});

fig = figure('Position',[0 0 430 400]);
fig2=figure;
axes1 = axes('Parent',fig);
rgbImg= colorize(hcube,"Method","rgb","ContrastStretching",true);
%title('RGB Image of Data Cube')
imagesc(rgbImg,'Parent',axes1);
axis off
axes2 = axes('Parent',fig2);
imagesc(classMap,'Parent',axes2)
axis off
colormap(jet(numel(classNames(2:5))))
title('Pixel-wise Classification Map')
ticks = linspace(2.4,4.9,numel(classNames(2:5)));
colorbar('Ticks',ticks,'TickLabels',classNames(2:5))
