% +---------------------+
% | Radovan Krizanovsky | 
% +---------------------+
% |     Uloha BONUS     |
% +---------------------+

% clear;
clc;
close all;

% Nacitanie predtrenovanej siete alexnet
net = alexnet;
analyzeNetwork(net);
layers = net.Layers;

% budeme kategorizovat
layers(23) = fullyConnectedLayer(10);
layers(25) = classificationLayer;

% dataset obrazkov
images = imageDatastore('C:\Users\rakri\Documents\MATLAB\trainingSet','IncludeSubfolders',true,'LabelSource','foldernames');

% rozdelenie obrazkov na trenovacie a validacne
[trainingImages, validoationImages] = splitEachLabel(images, 0.8, 'randomized');

% zmena velkosti obrazkov
imageSize = [227 227 3];
augTrainingImages = augmentedImageDatastore(imageSize, trainingImages, "ColorPreprocessing", "gray2rgb");
augValidationImages = augmentedImageDatastore(imageSize, validoationImages,"ColorPreprocessing", "gray2rgb");

% trenovacie nastavenia
options = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.001, ...
    'MaxEpochs', 3, ...
    'MiniBatchSize', 64, ...
    'ValidationData',augValidationImages, ...
    'ValidationFrequency',10, ...
    'Plots','training-progress');

% samotne trenovanie
trainedNet = trainNetwork(augTrainingImages, layers, options);

% vypocet presnosti
predictedLabels = classify(trainedNet, augValidationImages);
accuracy = mean(predictedLabels == validoationImages.Labels)

% otestovanie siete
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok1.jpg', trainedNet);
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok2.jpg', trainedNet);
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok3.jpg', trainedNet);
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok4.jpg', trainedNet);
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok5.jpg', trainedNet);
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok6.jpg', trainedNet);
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok7.jpg', trainedNet);
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok8.jpg', trainedNet);
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok9.jpg', trainedNet);
tryImage('C:\Users\rakri\Documents\MATLAB\testingImages\Obrazok10.jpg', trainedNet);

function tryImage(location, readyNet)
    testImage = imread(location);
    sz = [227 227 3];
    resizedTestImage = imresize(testImage, sz(1:2));
    label = classify(readyNet, resizedTestImage);
    figure;
    imshow(testImage);
    text(20, 20, char(label), 'Color', 'red','FontSize', 20, 'FontWeight', 'bold');
end