% +---------------------+
% | Radovan Krizanovsky | 
% +---------------------+
% |       Uloha 5       |
% +---------------------+

clear;
clc;
close all;

% Pouzivame "datafun.mat"
load("datafun");

% x, y – vstupná a výstupná premenná funkcie pre trénovanie siete, zobrazenie (plot) 
% indx_train, indx_test – indexy pre indexové rozdelenie dát na trénovacie a testovacie data 

% Struktura NS
net = fitnet([15 15]);

% Parametre trenovania
net.trainParam.goal = 1e-4;
net.trainParam.show = 5;        
net.trainParam.epochs = 500;

% Indexove rozdelenie dat
net.divideFcn='divideind';

len = length(y);
len2 = fix(len/2);

net.divideParam.trainInd = indx_train;
net.divideParam.testInd = indx_test;

% Vlastne rozdelenie
% net.divideParam.trainInd = indx_train;
% net.divideParam.valInd = 2:2:len2;
% net.divideParam.testInd = indx_test;

% Trenovanie
net = train(net,x,y);

% Simulacia vystupu NS
outnetsim = sim(net,x);

% Vykreslenie spravneho grafu povodnych hodnot a grafu hodnot podla NS
f1 = figure(1);
f1.Position = [800 50 500 500];
plot(y, "r");

f2 = figure(2);
f2.Position = [1300 50 500 500];
plot(x,y,'r',x,outnetsim,'b');



fprintf("Trenovacie Data: \n")

% Suma kvadratov odchyliek medzi meranym vystupom a vystupom siete
trainSSE = sse(net,y(indx_train),net(x(indx_train)));
fprintf("\nSSE: ");
disp(trainSSE);

% Priemer z SSE
trainMSE = mse(net,y(indx_train),net(x(indx_train)));
fprintf("MSE: ");
disp(trainMSE);

% Maximalna absolutna odchylka medzi meranym vystupom a vystupom siete
trainMAE = mae(net,y(indx_train),net(x(indx_train)));
fprintf("MAE: ");
disp(trainMAE);


fprintf("\nTestovacie Data: \n")

% Suma kvadratov odchyliek medzi meranym vystupom a vystupom siete
ERRsse = sse(net,y(indx_test),net(x(indx_test)));
fprintf("\nSSE: ");
disp(ERRsse);

% Priemer z SSE
ERRmse = mse(net,y(indx_test),net(x(indx_test)));
fprintf("MSE: ");
disp(ERRmse);

% Maximalna absolutna odchylka medzi meranym vystupom a vystupom siete
ERRmae = mae(net,y(indx_test),net(x(indx_test)));
fprintf("MAE: ");
disp(ERRmae);