% Clear command window and workspace
% clc
% clear

% Load the wavelengths data
load("wavelengths.mat")

% Load the endmembersppi data which contains the PPI algorithm-extracted spectral signatures
load('sup_sam_sign_ppi.mat') %endmembersppi

% Load the signatures data which contains the signature of pixels recognized as trees
load("unlabeled_tree_positions_signatures.mat") %% signature of pixels recognized as trees

% Get the size of the signatures
cnzi=size(signatures,1);

% Define the number of endmembers
numEndmembers=2;

% Reshape the signatures
signaturesr=reshape(signatures(:,3:49),[cnzi/13,13,47]);

% Initialize the score matrix
score = zeros(cnzi/13,13,numEndmembers);

% Calculate the SAM score for each endmember
for i=1:numEndmembers
    score(:,:,i)=sam(signaturesr,endmembersppi(:,i));
end

% Find the minimum score and its corresponding index
[~,matchingIndx] = min(score,[],3);

% Reshape the matching index
matchingIndx=reshape(matchingIndx-1,[cnzi 1]);

% Create a new figure
f1=figure(1);

% Load the hypercube data
hcube=hypercube('crop_trees.dat','crop_trees.hdr');

% Display the hypercube data
imshow(colorize(hcube,'Method','rgb','ContrastStretching',true))

% Hold the current plot
hold on;

% Set the x and y limits of the current plot
xlim([0 1368])
ylim([0 1480])

bluePoints = [];
redPoints = [];

for i=(1:cnzi)
    if(matchingIndx(i)==0)
        bluePoints = [bluePoints; signatures(i,1), signatures(i,2)];
    else
        redPoints = [redPoints; signatures(i,1), signatures(i,2)];
    end
end
for i=(1:size(convxy,1))
    if(convxy(i,3)==0)
        plot(convxy(i,1),convxy(i,2),'r+','MarkerSize',4)
    else
        plot(convxy(i,1),convxy(i,2),'b+','MarkerSize',4)
    end
end
%% 

% Track blue points
scatter(bluePoints(:,2), bluePoints(:,1), 1, 'b', 'filled', 'Marker', 'o')

hold on;

% Track red points
scatter(redPoints(:,2), redPoints(:,1), 1, 'm', 'filled', 'Marker', 'o')

xlim([0 1368])
ylim([0 1480])

% Set the title of the current plot
title({'Spectral Matches with ppi',['Number of Endmembers = ' num2str(numEndmembers)]});
