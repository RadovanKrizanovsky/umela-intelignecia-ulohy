% +---------------------+
% | Radovan Krizanovsky | 
% +---------------------+
% |       Uloha 4       |
% +---------------------+

clear;
clc;
close all;

% Pouzivame "databody.mat"
load("databody");

% Vykreslenie jednotlivych bodov z "databody.mat" do 3d grafu
graph = figure(1);
plot3(data1(:,1), data1(:,2), data1(:,3), "+cyan");
hold on;
plot3(data2(:,1), data2(:,2), data2(:,3), "*g");
plot3(data3(:,1), data3(:,2), data3(:,3), "ob");
plot3(data4(:,1), data4(:,2), data4(:,3), ".black");
plot3(data5(:,1), data5(:,2), data5(:,3), "smagenta");
title("Data Body");
xlabel("X");
ylabel("Y");
zlabel("Z");
grid on;
axis([0 1 0 1 0 1]);

% Spojenie skupin dat a transponacia (vstupne data)
X = [data1; data2; data3; data4; data5];
X = X';

% Zatriedenie bodov do skupin (vystupne data)
G = [ones(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50);
     zeros(1, 50), ones(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50);
     zeros(1, 50), zeros(1, 50), ones(1, 50), zeros(1, 50), zeros(1, 50);
     zeros(1, 50), zeros(1, 50), zeros(1, 50), ones(1, 50), zeros(1, 50);
     zeros(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50), ones(1, 50)];

% Struktura NS
net = patternnet(15);

% Volba chybovej funkcie a podmienky ukoncenia
net.performFcn = 'crossentropy';
net.trainParam.goal = 1e-6;
net.trainParam.epochs = 500;
net.trainParam.min_grad = 1e-10;

% Nahodne rozdelenie dat v percentualnych pomeroch
net.divideFcn='dividerand';
net.divideParam.trainRatio = 0.8;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0.2;

% Trenovanie
net = train(net,X,G);

% Percentuale pomery
% percentage = net(X);

% Finalne rozhodnutia
% types = vec2ind(percentage);

% Suradnice testovanych bodov
X2 = [rand(1) rand(1) rand(1) rand(1) rand(1);
      rand(1) rand(1) rand(1) rand(1) rand(1);
      rand(1) rand(1) rand(1) rand(1) rand(1)];

% Percentuale pomery
percentage2 = net(X2);

% Finalne rozhodnutia
types2 = vec2ind(percentage2);

% Finalny vypis a vykreslenie testovanych bodov v grafe
fprintf('Rozdelenie testovanych bodov: \n');

for point = 1:5
    switch types2(point)
        case 1
            plot3(X2(1,point), X2(2,point), X2(3,point),"dcyan");
            fprintf("| Bod %d | Farba Tyrkysova | Skupina %d | ", point, types2(point));
        case 2
            plot3(X2(1,point), X2(2,point), X2(3,point),"dg");
            fprintf("| Bod %d | Farba Zelena    | Skupina %d | ", point, types2(point));
        case 3
            plot3(X2(1,point), X2(2,point), X2(3,point),"db");
            fprintf("| Bod %d | Farba Modra     | Skupina %d | ", point, types2(point));
        case 4
            plot3(X2(1,point), X2(2,point), X2(3,point),"dblack");
            fprintf("| Bod %d | Farba Cierna    | Skupina %d | ", point, types2(point));
        case 5
            plot3(X2(1,point), X2(2,point), X2(3,point),"dmagenta");
            fprintf("| Bod %d | Farba Fialova   | Skupina %d | ", point, types2(point));
    end
    fprintf("\n");

% Zvyraznenie testovanych bodov v grafe
redLineBegining = [X2(1,point), X2(2,point), X2(3,point)];
redLineEnd = [X2(1,point), X2(2,point), X2(3,point)+0.2];
redLine = [redLineBegining;redLineEnd];
plot3(redLine(:,1),redLine(:,2),redLine(:,3),'r');

end