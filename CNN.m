%bring shit in
%{
fname = 'train.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);
%}

%just print everything
%{
for n = 1:length(val)
fprintf('id: %s\n angle: %d\n avg band1: %d\n avg band2: %d\n is_iceberg: %d\n', ...
val(n).id,val(n).inc_angle, mean(val(n).band_1), mean(val(n).band_2), val(n).is_iceberg)
end
%}

%put the files into an image datastore with labels ship or iceberg
imds = imageDatastore(strcat(pwd,'\images'),...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

%select some random images and show them
%{
numImages = 1400;
perm = randperm(numImages,20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end
%}
%{
tested with:
200
%}
numTrainingFiles = 600;
[imdsTrain,imdsTest] = splitEachLabel(imds,numTrainingFiles,'randomize');
      
layers = [
    imageInputLayer([75 75 1])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];
%this layer doesnt get anything good
%{
layers = [imageInputLayer([75 75 1]);
          convolution2dLayer(5,16); %wtf do with this
          reluLayer(); %wtf is this
          maxPooling2dLayer(2,'Stride',2);
          fullyConnectedLayer(2); %cant be 3
          softmaxLayer();
          classificationLayer()];
    
    %}
%doesnt work well either 
%{
options = trainingOptions('sgdm',...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',0.2,...
    'LearnRateDropPeriod',5,...
    'MaxEpochs',200,...
    'Verbose', 1,...
    'Plots','training-progress');
%}

%does its job. kinda
options = trainingOptions('sgdm', ...
    'MaxEpochs',200,...
    'InitialLearnRate',1e-4, ...
    'Verbose',0, ...
    'Plots','training-progress');
          
net = trainNetwork(imdsTrain,layers,options);

YPred = classify(net,imdsTest);
YTest = imdsTest.Labels;

accuracy = sum(YPred == YTest)/numel(YTest)