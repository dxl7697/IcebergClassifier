%put the files into an image datastore with labels ship or iceberg
imds = imageDatastore(strcat(pwd,'\images\rotateTwoDim'),...
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
numTrainingFiles = 450;
[imdsTrain,imdsTest] = splitEachLabel(imds,.6,'randomized');
%[imdsTrain,imdsTest] = splitEachLabel(imds,numTrainingFiles,'randomized');

layers = [
    imageInputLayer([75 75 3])
    
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
    
    dropoutLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];


options = trainingOptions('sgdm', ...
    'MaxEpochs',200,...
    'InitialLearnRate',.0001, ...
    'Plots','training-progress');
tic;          
for i = 1:4
    [imdsTrain,imdsTest] = splitEachLabel(imds,.6,'randomized');
    %[imdsTrain,imdsTest] = splitEachLabel(imds,numTrainingFiles,'randomized');

    net = trainNetwork(imdsTrain,layers,options);

    YPred = classify(net,imdsTest);
    YTest = imdsTest.Labels;

    accuracy = sum(YPred == YTest)/numel(YTest);
    disp(accuracy);
end
toc;
disp("DONE");
