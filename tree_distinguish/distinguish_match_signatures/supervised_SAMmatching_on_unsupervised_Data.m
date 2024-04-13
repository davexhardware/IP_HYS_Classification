clc
clear
% We will try to apply SAM to the labeled spectral signatures of trees:
% We will use the PPI algorithm-extracted spectral signatures from the
% labeled dataset and apply them to the whole tree's crop on the image

load("wavelengths.mat")
load('sup_sam_sign_ppi.mat') %endmembersppi

load("unlabeled_tree_positions_signatures.mat") %% signature of pixels recognized as trees
cnzi=size(signatures,1);
numEndmembers=2;
signaturesr=reshape(signatures(:,3:49),[cnzi/13,13,47]);
score = zeros(cnzi/13,13,numEndmembers);
for i=1:numEndmembers
    score(:,:,i)=sam(signaturesr,endmembersppi(:,i));
end
[~,matchingIndx] = min(score,[],3);
matchingIndx=reshape(matchingIndx-1,[cnzi 1]);
f1=figure(1);
hcube=hypercube('crop_trees.dat','crop_trees.hdr');
imshow(colorize(hcube,'Method','rgb','ContrastStretching',true))
hold on;
xlim([0 1368])
ylim([0 1480])
for i=(1:cnzi)
    if(matchingIndx(i)==0)
        plot(signatures(i,2),signatures(i,1),'b.','MarkerSize',1,'LineWidth',1)
    else
        plot(signatures(i,2),signatures(i,1),'r.','MarkerSize',1,'LineWidth',1)
    end
end
title({'Spectral Matches with ppi',['Number of Endmembers = ' num2str(numEndmembers)]});