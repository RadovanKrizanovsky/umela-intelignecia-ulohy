% +---------------------+
% | Radovan Krizanovsky | 
% +---------------------+
% |       Uloha 2       |
% +---------------------+

clear;clc

B=[0,0; 77,68; 12,75; 32,17; 51,64; 20,19; 72,87; 80,37; 35,82;
2,15; 18,90; 33,50; 85,52; 97,27; 37,67; 20,82; 49,0; 62,14; 7,60;
100,100];

%=================================================
% Nastavenia
generations = 3000;
initialSwapgenrate = 1;
popSize = 20;
lineThickness = 0.5;
color = "b";
holdOnOff = 1; % |1 = On|  |0 = Off|
values = 1;
%=================================================

if holdOnOff ~= 1
    close all;
end

% Populacia s ktorou budeme pracovat
population =   [swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);
                swapgen([2:1:19],initialSwapgenrate);];

% Priestor pre hodnoty do grafu
grafFit = zeros(1, generations);

% Generacne meniace sa hodnoty pre jedincov
valuesPerSpecimen = (zeros(1,popSize));

% Generacny cyklus
for generation = 1 : 1 : generations

    % Hodnotenie jedincov
    for order = 1 : 1 : popSize
        valuesPerSpecimen(order) = roadLength(population(order,:), B, popSize);
    end

    % Zaznam hodnot kazdu generaciu pre finalny graf
    grafFit(generation) = min(valuesPerSpecimen);
    
    % Selekcia jedincov
    population1 = selbest(population, valuesPerSpecimen, [3,1,1]);
    population2 = selsus(population, valuesPerSpecimen, 5);
    population3 = selsus(population, valuesPerSpecimen, 6);
    population4 = selrand(population, valuesPerSpecimen, 4);

    % Mutovanie a krizenie populacie
    population1 = crosord(population1, 1);
  
    population2 = crosord(population2, 0);
    population2 = swapgen(population2, 0.2);

    population3 = crosord(population3, 0);
    population3 = swappart(population3, 0.5);
    population3 = swapgen(population3, 0.5);

    %population4 = crosord(population4, 0);
    population4 = swappart(population4, 0.8);
    population4 = swapgen(population4, 0.8);
    
    population34 = [population3;population4];
    population34 = crosord(population34, 1);
    
    % Finalna populacia pre danu generaciu
    population = [population1;population2;population34];


end

%==========================================================================
% Grafy

%Poradie suradnic najlepsieho
best = selbest(population, valuesPerSpecimen, [1]);

% Inicializacia tabulky pre dvojice suradnic
firstBest = [0,0];
lastBest = [100,100];
wholeBest = [zeros(1, popSize); zeros(1, popSize)];
wholeBest = wholeBest';
wholeBest(1,:) = firstBest;

% Naplnenie tabulky postupnostou suradnic
genOrderBest = 2;
for genBest = best
    wholeBest(genOrderBest,:) = B(genBest,:);
    genOrderBest = genOrderBest + 1;  
end
wholeBest(popSize,:) = lastBest;

checkHoldOnOff(holdOnOff)

% graf 1
f1 = figure(1);
f1.Position = [800 50 500 500];

xka = plot(B(:,1),B(:,2), "Xr");
xka.LineWidth = 1.5;

hold on;
p = plot(wholeBest(:,1), wholeBest(:,2), color);
p.LineWidth = lineThickness;
hold off;

checkHoldOnOff(holdOnOff)

grid;
xlabel('X');
ylabel('Y');
title('Cesta');

checkHoldOnOff(holdOnOff)

% graf 2
f2 = figure(2);
f2.Position = [1300 50 500 500];

plot(grafFit, color);

grid;
ylabel('Najlepsia hodnota');
xlabel('Generacia');
title('Priebeh Funkcie');

checkHoldOnOff(holdOnOff)


%==========================================================================


%==========================================================================
% Vypisy
if values == 1
    fprintf("========================================================================================================================================================================================\n");
    fprintf("Farba: %s\n", color);
    fprintf("Najkratsia najdena cesta: %f\n", roadLength(best, B, 20));
    fprintf("----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    fprintf("Postupnost bodov:");
    Suradnice = wholeBest'
    fprintf("\n========================================================================================================================================================================================\n");
end

%==========================================================================

% Vypoceet dlzky cesty na zaklade vstupneho chromozonu
function [length] = roadLength(chromosone, B, popSize)

   length = 0;

    % Inicializacia tabulky pre dvojice suradnic
    first = [0,0];
    last = [100,100];
    whole = [zeros(1, popSize); zeros(1, popSize)];
    whole = whole';
    whole(1,:) = first;

    % Naplnenie tabulky postupnostou suradnic
    genOrder = 2;
    for gen = chromosone
        whole(genOrder,:) = B(gen,:);
        genOrder = genOrder + 1;  
    end
    whole(popSize,:) = last;
    
    for bod = 1 : (popSize-1)
        xDist = whole(bod+1,1) - whole(bod,1);
        yDist = whole(bod+1,2) - whole(bod,2);
        length = length + (sqrt(((xDist^2) + (yDist^2))));
    end

end

% Kontrola nastavenia hold on/off
function checkHoldOnOff(onOff)

    if onOff == 1
        hold on;
    else
        hold off;
    end

end
