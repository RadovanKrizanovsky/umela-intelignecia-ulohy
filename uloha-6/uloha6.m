% +---------------------+
% | Radovan Krizanovsky | 
% +---------------------+
% |       Uloha 6       |
% +---------------------+

clear;
clc;
close all;

% Pouzivame "dataarytmiasrdca.mat"
load("dataarytmiasrdca.mat");

% Rozdelenie ludi na chorych a zdravych
sizeIllnesess = size(typ_ochorenia,1);
illOrNot = zeros(2, sizeIllnesess);

succes = zeros(10,3);

for i = 1 : sizeIllnesess
    if typ_ochorenia(i) == 1
        illOrNot(1, i) = 1;
    else
        illOrNot(2,i) = 1;
    end
end

% Celkovy algoritmus spustime 10 krat
for repeat = 1 : 10
    
    % Struktura NS
    net = patternnet(20);

    % Parametre trenovania
    net.trainParam.goal = 0.1;
    net.trainParam.show = 5;
    net.trainParam.epochs = 150;
    net.trainParam.min_grad = 1e-4;

    % Nahodne rozdelenie dat v percentualnych pomeroch
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 0.6; 
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0.4;
    
    % Trenovanie
    input = NDATA';
    [net,tr] = train(net,input,illOrNot);
    
    % Vystup a confusion pre celkove data
    out = net(input);
    [c,cm] = confusion(illOrNot,out);

    % Vystup a confusion pre trenovacie data
    outTrain = net(input(:,tr.trainInd));
    trainingResult = illOrNot(:,tr.trainInd);
    [ctrain,cmTrain] = confusion(trainingResult,outTrain);

    % Vystup a confusion pre testovacie data
    outTest = net(input(:,tr.testInd));
    testingResult = illOrNot(:,tr.testInd);
    [ctest,cmTest] = confusion(testingResult,outTest);
    
    % Vypis pre kazdy beh algoritmu
    fprintf("%d. beh\n", repeat);
    fprintf("| Uspesnost klasifikacie:\n" );
    fprintf("| Trenovanie: %.4f | Testovanie: %.4f | Celkova: %.4f \n\n", 100*(1-ctrain),100*(1-ctest), 100*(1-c));

    fprintf('| Senzitivita a specificita (trenovacie data):   %.4f %.4f\n', cmTrain(2,2)/(cmTrain(2,2)+cmTrain(2,1)), cmTrain(1,1)/(cmTrain(1,1)+cmTrain(1,2)));
    fprintf('| Senzitivita a specificita (testovacie data):   %.4f %.4f\n', cmTest(2,2)/(cmTest(2,2)+cmTest(2,1)), cmTest(1,1)/(cmTest(1,1)+cmTest(1,2)));
    fprintf('| Senzitivita a specificita (celkove data):      %.4f %.4f\n\n', cm(2,2)/(cm(2,2)+cm(2,1)), cm(1,1)/(cm(1,1)+cm(1,2)));
    
    % Zapis uspesnosti celkovych dat a rozdelenych
    succes(repeat,1) = 100*(1-c);
    succes(repeat,2) = 100*(1-ctrain);
    succes(repeat,3) = 100*(1-ctest);
    
    % Testovanie siete na jedincovi
    %testOutput = net(input(:,repeat))
end

% Zaverecny vypis statistik
fprintf("--------------------------------------------------------------\n\n");
minSucces = min(succes);
maxSucces = max(succes);
meanSucces = mean(succes);

fprintf("| Uspesnost klasifikacie (trenovanie):\n" );
fprintf("| Najhorsia: %.4f | Najlepsia: %.4f | Priemerna: %.4f \n\n", minSucces(2), maxSucces(2), meanSucces(2));

fprintf("| Uspesnost klasifikacie (testovanie):\n" );
fprintf("| Najhorsia: %.4f | Najlepsia: %.4f | Priemerna: %.4f \n\n", minSucces(3), maxSucces(3), meanSucces(3));

fprintf("| Uspesnost klasifikacie (celkove):\n" );
fprintf("| Najhorsia: %.4f | Najlepsia: %.4f | Priemerna: %.4f\n", minSucces(1), maxSucces(1), meanSucces(1));