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


%does its job. kinda
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