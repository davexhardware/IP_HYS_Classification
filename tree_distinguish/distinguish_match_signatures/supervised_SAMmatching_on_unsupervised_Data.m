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

% Plot the signatures based on the matching index
for i=(1:cnzi)
    if(matchingIndx(i)==0)
        plot(signatures(i,2),signatures(i,1),'b.','MarkerSize',1,'LineWidth',1)
    else
        plot(signatures(i,2),signatures(i,1),'r.','MarkerSize',1,'LineWidth',1)
    end
end

% Set the title of the current plot
title({'Spectral Matches with ppi',['Number of Endmembers = ' num2str(numEndmembers)]});
