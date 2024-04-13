clc
clear
% We will try to apply SAM to the labeled spectral signature of the tree:
% That would be like clustering the trees with a similar spectrum,
% but we don't have any definitive, differentiate spectral signatures
% informations for the two types of trees labeled as "Leccino", "Ogliarola
% barese" , so we'll take two distinguished signatures from our labeled 
% dataset and test the accuracy

load("wavelengths.mat")
load('labeled_tree_coordinates_firms.mat')
hcube=hypercube('crop_trees.dat','crop_trees.hdr');
% signatures=zeros(223327,49); %NUMBER OF PIXELS RECOGNIZED AS TREES
% cnzi=1;
% for i=(1:size(hcube.DataCube,1))
%     for j=(1:size(hcube.DataCube,2))
%         if(hcube.DataCube(i,j,:)~=zeros(size(hcube.DataCube(i,j,:))))
%             signatures(cnzi,1:2)=[i,j];
%             signatures(cnzi,3:49)=hcube.DataCube(i,j,:); %% signature of pixels recognized as trees
%             cnzi=cnzi+1;
%         end
%     end
% end
load("unlabeled_tree_positions_signatures.mat")
cnzi=size(signatures,1);
%%
signaturesr=reshape(signatures(:,3:49),[cnzi/13,13,47]);
%%
l=1;
o=1;
for i=(1:size(convxy,1))
    if(convxy(i,3)==0) %LECCINO
        signLecc(l,:)=convxy(i,4:50);
        l=l+1;
    else % OGLIAROLA
        signOglia(o,:)=convxy(i,4:50);
        o=o+1;
    end
end
size(signLecc)
size(signOglia)
meanOglia=mean(signOglia,1);
meanLecc=mean(signLecc,1);
numEndmembers=2; %add the 0 values as match
calcNumEndmembers=countEndmembersHFC(signaturesr)
endmembers = nfindr(signaturesr,numEndmembers,'ReductionMethod','MNF');
% endmembersfippi=fippi(signaturesr,numEndmembers,'ReductionMethod','MNF'); %fast iterative pixel purity index
% endmembersppi=ppi(signaturesr,numEndmembers,'ReductionMethod','MNF');
figure(1)
plot(endmembers)
legend('end1','end2')
hold on;
plot(meanOglia,'Color','g','DisplayName','meanOgliarola')
plot(meanLecc,'Color','m','DisplayName','meanLeccino')
xlabel('Band Number')
ylabel('Pixel Values')
ylim([0 1])
title({'Endmembers Spectra with n-findr',['Number of Endmembers = ' num2str(numEndmembers)]});
% figure(2)
% plot(endmembersfippi)
% legend('end1','end2')
% hold on;
% plot(meanOglia,'Color','g','DisplayName','meanOgliarola')
% plot(meanLecc,'Color','m','DisplayName','meanLeccino')
% xlabel('Band Number')
% ylabel('Pixel Values')
% ylim([0 1])
% title({'Endmembers Spectra with fippi',['Number of Endmembers = ' num2str(numEndmembers)]});
% figure(3)
% plot(endmembersppi)
% legend('end1','end2')
% hold on;
% plot(meanOglia,'Color','g','DisplayName','meanOgliarola')
% plot(meanLecc,'Color','m','DisplayName','meanLeccino')
% xlabel('Band Number')
% ylabel('Pixel Values')
% ylim([0 1])
% title({'Endmembers Spectra with ppi',['Number of Endmembers = ' num2str(numEndmembers)]});
%% Now we evaluate the similarity of each labeled tree's spectrum to the two extracted spectrums
score = zeros(cnzi/13,13,numEndmembers);
% scorefippi=zeros(cnzi/13,13,numEndmembers);
scoreppi=zeros(cnzi/13,13,numEndmembers);
for i=1:numEndmembers
    score(:,:,i)=sam(signaturesr,endmembers(:,i));
%     scorefippi(:,:,i)=sam(signaturesr,endmembersfippi(:,i));
%     scoreppi(:,:,i)=sam(signaturesr,endmembersppi(:,i));
end
[~,matchingIndx] = min(score,[],3);
% [~,matchingFippi] = min(scorefippi,[],3);
% [~,matchingppi] = min(scoreppi,[],3);
% matchingFippi=reshape(matchingFippi-1,[cnzi 1]);
matchingIndx=reshape(matchingIndx-1,[cnzi 1]);
% matchingppi=reshape(matchingppi-1,[cnzi 1]);
f4=figure(4);
imshow(colorize(hcube,'Method','rgb','ContrastStretching',true))
hold on;
xlim([0 1368])
ylim([0 1480])
for i=(1:cnzi)
    if(matchingIndx(i)==0)
        plot(signatures(i,2),signatures(i,1),'r.','MarkerSize',1,'LineWidth',1)
    else
        plot(signatures(i,2),signatures(i,1),'b.','MarkerSize',1,'LineWidth',1)
    end
end
title({'Spectral Matches with n-findr',['Number of Endmembers = ' num2str(numEndmembers)]});
% figure(5)
% imshow(colorize(hcube,'Method','rgb','ContrastStretching',true))
% hold on;
% xlim([0 1368])
% ylim([0 1480])
% for i=(1:9:cnzi)
%     if(matchingFippi(i)==0)
%         plot(signatures(i,2),signatures(i,1),'r.','MarkerSize',1,'LineWidth',1)
%     else
%         plot(signatures(i,2),signatures(i,1),'b.','MarkerSize',1,'LineWidth',1)
%     end
% end
% title({'Spectral Matches with fippi',['Number of Endmembers = ' num2str(numEndmembers)]});
% figure(6)
% imshow(colorize(hcube,'Method','rgb','ContrastStretching',true))
% hold on;
% xlim([0 1368])
% ylim([0 1480])
% for i=(1:9:cnzi)
%     if(matchingppi(i)==0)
%         plot(signatures(i,2),signatures(i,1),'r.','MarkerSize',1,'LineWidth',1)
%     else
%         plot(signatures(i,2),signatures(i,1),'b.','MarkerSize',1,'LineWidth',1)
%     end
% end
% title({'Spectral Matches with ppi',['Number of Endmembers = ' num2str(numEndmembers)]});
% accuracy=sum(convxy(1:80,3)==matchingIndx,'all')/numel(matchingIndx)
% accuracyfippi=sum(convxy(1:80,3)==matchingFippi,'all')/numel(matchingFippi)
% accuracyppi=sum(convxy(1:80,3)==matchingppi,'all')/numel(matchingppi)