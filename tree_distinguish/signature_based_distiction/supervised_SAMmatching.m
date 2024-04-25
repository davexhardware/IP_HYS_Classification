clc
clear
% We will try to apply SAM to the labeled spectral signatures of the trees:
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
size(signLecc);
size(signOglia);
meanOglia=mean(signOglia,1);
meanLecc=mean(signLecc,1);
numEndmembers=2;
suggestedEndmembers=countEndmembersHFC(signatures) %suggested number of 
%%
% different spectral signatures that could optimally be extracted from the
% whole trees dataset
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

%% Now we evaluate the similarity of each labeled tree's spectrum to the two extracted spectrums - all bands
score = zeros(2,40,numEndmembers);
scorefippi=zeros(2,40,numEndmembers);
scoreppi=zeros(2,40,numEndmembers);
scoremean=zeros(2,40,numEndmembers);
for i=1:numEndmembers
    score(:,:,i)=sam(signatures,endmembers(:,i));
    scorefippi(:,:,i)=sam(signatures,endmembersfippi(:,i));
    scoreppi(:,:,i)=sam(signatures,endmembersppi(:,i));
    if i==1
        scoremean(:,:,i)=sam(signatures,meanLecc);
    else
        scoremean(:,:,i)=sam(signatures,meanOglia);
    end
end
[~,matchingIndx] = min(score,[],3);
[~,matchingFippi] = min(scorefippi,[],3);
[~,matchingppi] = min(scoreppi,[],3);
[~,matchingmean]=min(scoremean,[],3);
matchingFippi=reshape(matchingFippi-1,[80 1]);
matchingIndx=reshape(1-(matchingIndx-1),[80 1]);
matchingppi=reshape(1-(matchingppi-1),[80 1]);
matchingmean=reshape(matchingmean,[80 1]);
% Calcolo dell'accuratezza per le classi 0 e 1
% Calcolo dei valori di accuratezza
accuracy_0_nfr = sum((convxy(1:80,3)==0) & (matchingIndx==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_nfr = sum((convxy(1:80,3)==1) & (matchingIndx==1))/sum(convxy(1:80,3)==1)*100;
accuracynfr=sum(convxy(1:80,3)==matchingIndx,'all')/numel(matchingIndx)*100;

accuracy_0_mean = sum((convxy(1:80,3)==0) & (matchingmean==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_mean = sum((convxy(1:80,3)==1) & (matchingmean==1))/sum(convxy(1:80,3)==1)*100;
accuracymean=sum(convxy(1:80,3)==matchingmean,'all')/numel(matchingmean)*100;

accuracy_0_Fippi = sum((convxy(1:80,3)==0) & (matchingFippi==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_Fippi = sum((convxy(1:80,3)==1) & (matchingFippi==1))/sum(convxy(1:80,3)==1)*100;
accuracyfippi=sum(convxy(1:80,3)==matchingFippi,'all')/numel(matchingFippi)*100;

accuracy_0_Ppi = sum((convxy(1:80,3)==0) & (matchingppi==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_Ppi = sum((convxy(1:80,3)==1) & (matchingppi==1))/sum(convxy(1:80,3)==1)*100;
accuracyppi=sum(convxy(1:80,3)==matchingppi,'all')/numel(matchingppi)*100;
fprintf('################# All bands ####################\n')
% Creazione di un array con i valori di accuratezza
accuracies = [accuracy_0_mean,accuracy_1_mean,accuracymean;accuracy_0_nfr, accuracy_1_nfr, accuracynfr; accuracy_0_Fippi, accuracy_1_Fippi, accuracyfippi; accuracy_0_Ppi, accuracy_1_Ppi, accuracyppi];

% Creazione di una tabella
accuracies_table = array2table(accuracies, 'VariableNames', {'Accuratezza Classe Leccino', 'Accuratezza Classe Ogliarola', 'Accuratezza Generale'}, 'RowNames', {'Avg Signatures','N-FINDR', 'Fippi', 'Ppi'});

% Visualizzazione della tabella
disp(accuracies_table);

%% Now we evaluate the similarity of each labeled tree's spectrum to the two extracted spectrums - till 32nd band
score = zeros(2,40,numEndmembers);
scorefippi=zeros(2,40,numEndmembers);
scoreppi=zeros(2,40,numEndmembers);
for i=1:numEndmembers
    score(:,:,i)=sam(signatures(:,:,1:32),endmembers(1:32,i));
    scorefippi(:,:,i)=sam(signatures(:,:,1:32),endmembersfippi(1:32,i));
    scoreppi(:,:,i)=sam(signatures(:,:,1:32),endmembersppi(1:32,i));
    if i==1
        scoremean(:,:,i)=sam(signatures(:,:,1:32),meanLecc(1:32));
    else
        scoremean(:,:,i)=sam(signatures(:,:,1:32),meanOglia(1:32));
    end
end
[~,matchingIndx] = min(score,[],3);
[~,matchingFippi] = min(scorefippi,[],3);
[~,matchingppi] = min(scoreppi,[],3);
[~,matchingmean]=min(scoremean,[],3);

matchingFippi=reshape(matchingFippi-1,[80 1]);
matchingIndx=reshape(1-(matchingIndx-1),[80 1]);
matchingppi=reshape(1-(matchingppi-1),[80 1]);
matchingmean=reshape(matchingmean,[80 1]);
% Calcolo dell'accuratezza per le classi 0 e 1
% Calcolo dei valori di accuratezza
accuracy_0_nfr = sum((convxy(1:80,3)==0) & (matchingIndx==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_nfr = sum((convxy(1:80,3)==1) & (matchingIndx==1))/sum(convxy(1:80,3)==1)*100;
accuracynfr=sum(convxy(1:80,3)==matchingIndx,'all')/numel(matchingIndx)*100;

accuracy_0_mean = sum((convxy(1:80,3)==0) & (matchingmean==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_mean = sum((convxy(1:80,3)==1) & (matchingmean==1))/sum(convxy(1:80,3)==1)*100;
accuracymean=sum(convxy(1:80,3)==matchingmean,'all')/numel(matchingmean)*100;

accuracy_0_Fippi = sum((convxy(1:80,3)==0) & (matchingFippi==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_Fippi = sum((convxy(1:80,3)==1) & (matchingFippi==1))/sum(convxy(1:80,3)==1)*100;
accuracyfippi=sum(convxy(1:80,3)==matchingFippi,'all')/numel(matchingFippi)*100;

accuracy_0_Ppi = sum((convxy(1:80,3)==0) & (matchingppi==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_Ppi = sum((convxy(1:80,3)==1) & (matchingppi==1))/sum(convxy(1:80,3)==1)*100;
accuracyppi=sum(convxy(1:80,3)==matchingppi,'all')/numel(matchingppi)*100;
fprintf('################# First 32 bands ####################\n')
% Creazione di un array con i valori di accuratezza
accuracies = [accuracy_0_mean,accuracy_1_mean,accuracymean; accuracy_0_nfr, accuracy_1_nfr, accuracynfr; accuracy_0_Fippi, accuracy_1_Fippi, accuracyfippi; accuracy_0_Ppi, accuracy_1_Ppi, accuracyppi];

% Creazione di una tabella
accuracies_table = array2table(accuracies, 'VariableNames', {'Accuratezza Classe Leccino', 'Accuratezza Classe Ogliarola', 'Accuratezza Generale'}, 'RowNames', {'Avg Signatures','N-FINDR', 'Fippi', 'Ppi'});

% Visualizzazione della tabella
disp(accuracies_table);

%% Now we evaluate the similarity of each labeled tree's spectrum to the two extracted spectrums - from 32nd to 47th band
score = zeros(2,40,numEndmembers);
scorefippi=zeros(2,40,numEndmembers);
scoreppi=zeros(2,40,numEndmembers);
for i=1:numEndmembers
    score(:,:,i)=sam(signatures(:,:,32:47),endmembers(32:47,i));
    scorefippi(:,:,i)=sam(signatures(:,:,32:47),endmembersfippi(32:47,i));
    scoreppi(:,:,i)=sam(signatures(:,:,32:47),endmembersppi(32:47,i));
    if i==1
        scoremean(:,:,i)=sam(signatures(:,:,32:47),meanLecc(32:47));
    else
        scoremean(:,:,i)=sam(signatures(:,:,32:47),meanOglia(32:47));
    end
end
[~,matchingIndx] = min(score,[],3);
[~,matchingFippi] = min(scorefippi,[],3);
[~,matchingppi] = min(scoreppi,[],3);
[~,matchingmean]=min(scoremean,[],3);

matchingFippi=reshape(matchingFippi-1,[80 1]);
matchingIndx=reshape(1-(matchingIndx-1),[80 1]);
matchingppi=reshape(1-(matchingppi-1),[80 1]);
matchingmean=reshape(matchingmean,[80 1]);
% Calcolo dell'accuratezza per le classi 0 e 1
% Calcolo dei valori di accuratezza
accuracy_0_nfr = sum((convxy(1:80,3)==0) & (matchingIndx==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_nfr = sum((convxy(1:80,3)==1) & (matchingIndx==1))/sum(convxy(1:80,3)==1)*100;
accuracynfr=sum(convxy(1:80,3)==matchingIndx,'all')/numel(matchingIndx)*100;

accuracy_0_mean = sum((convxy(1:80,3)==0) & (matchingmean==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_mean = sum((convxy(1:80,3)==1) & (matchingmean==1))/sum(convxy(1:80,3)==1)*100;
accuracymean=sum(convxy(1:80,3)==matchingmean,'all')/numel(matchingmean)*100;

accuracy_0_Fippi = sum((convxy(1:80,3)==0) & (matchingFippi==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_Fippi = sum((convxy(1:80,3)==1) & (matchingFippi==1))/sum(convxy(1:80,3)==1)*100;
accuracyfippi=sum(convxy(1:80,3)==matchingFippi,'all')/numel(matchingFippi)*100;

accuracy_0_Ppi = sum((convxy(1:80,3)==0) & (matchingppi==0))/sum(convxy(1:80,3)==0)*100;
accuracy_1_Ppi = sum((convxy(1:80,3)==1) & (matchingppi==1))/sum(convxy(1:80,3)==1)*100;
accuracyppi=sum(convxy(1:80,3)==matchingppi,'all')/numel(matchingppi)*100;
fprintf('################# 32nd to 47th bands ####################\n')
% Creazione di un array con i valori di accuratezza
accuracies = [accuracy_0_mean,accuracy_1_mean,accuracymean; accuracy_0_nfr, accuracy_1_nfr, accuracynfr; accuracy_0_Fippi, accuracy_1_Fippi, accuracyfippi; accuracy_0_Ppi, accuracy_1_Ppi, accuracyppi];

% Creazione di una tabella
accuracies_table = array2table(accuracies, 'VariableNames', {'Accuratezza Classe Leccino', 'Accuratezza Classe Ogliarola', 'Accuratezza Generale'}, 'RowNames', {'Avg Signatures','N-FINDR', 'Fippi', 'Ppi'});

% Visualizzazione della tabella
disp(accuracies_table);

