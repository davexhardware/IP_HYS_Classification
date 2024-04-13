clc
clear
% We will try to apply SAM to the labeled spectral signature of the tree:
% That would be like clustering the trees with a similar spectrum,
% but we don't have any definitive, differentiate spectral signatures
% informations for the two types of trees labeled as "Leccino", "Ogliarola
% barese" , so we'll take two distinguished signatures from our labeled 
% dataset and test the accuracy

load("wavelengths.mat")
load("labeled_tree_coordinates_firms.mat")
signatures=zeros(2,40,47);
for i=(1:size(convxy,1)-2)
    signatures(floor(i/40)+1,mod(i,40)+1,:)=convxy(i,4:50);
end
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
numEndmembers=2;
endmembers = nfindr(signatures,numEndmembers);
endmembersfippi=fippi(signatures,numEndmembers); %fast iterative pixel purity index
endmembersppi=ppi(signatures,numEndmembers);
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
figure(2)
plot(endmembersfippi)
legend('end1','end2')
hold on;
plot(meanOglia,'Color','g','DisplayName','meanOgliarola')
plot(meanLecc,'Color','m','DisplayName','meanLeccino')
xlabel('Band Number')
ylabel('Pixel Values')
ylim([0 1])
title({'Endmembers Spectra with fippi',['Number of Endmembers = ' num2str(numEndmembers)]});
figure(3)
plot(endmembersppi)
legend('end1','end2')
hold on;
plot(meanOglia,'Color','g','DisplayName','meanOgliarola')
plot(meanLecc,'Color','m','DisplayName','meanLeccino')
xlabel('Band Number')
ylabel('Pixel Values')
ylim([0 1])
title({'Endmembers Spectra with ppi',['Number of Endmembers = ' num2str(numEndmembers)]});
%% Now we evaluate the similarity of each labeled tree's spectrum to the two extracted spectrums
score = zeros(2,40,numEndmembers);
scorefippi=zeros(2,40,numEndmembers);
scoreppi=zeros(2,40,numEndmembers);
for i=1:numEndmembers
    score(:,:,i)=sam(signatures,endmembers(:,i));
    scorefippi(:,:,i)=sam(signatures,endmembersfippi(:,i));
    scoreppi(:,:,i)=sam(signatures,endmembersppi(:,i));
end
[~,matchingIndx] = min(score,[],3);
[~,matchingFippi] = min(scorefippi,[],3);
[~,matchingppi] = min(scoreppi,[],3);
matchingFippi=reshape(matchingFippi-1,[80 1]);
matchingIndx=reshape(1-(matchingIndx-1),[80 1]);
matchingppi=reshape(1-(matchingppi-1),[80 1]);
accuracy=sum(convxy(1:80,3)==matchingIndx,'all')/numel(matchingIndx)
accuracyfippi=sum(convxy(1:80,3)==matchingFippi,'all')/numel(matchingFippi)
accuracyppi=sum(convxy(1:80,3)==matchingppi,'all')/numel(matchingppi)