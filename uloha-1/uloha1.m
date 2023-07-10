% +---------------------+
% | Radovan Krizanovsky | 
% +---------------------+
% |       Uloha 1       |
% +---------------------+

clear
close all
clc

% +----------------------------------------------------------------------------------------------------------+
% | Pouzivame nizsie definovanu funkciu geneticAlgorithm(generations, popSize, numOfGenes, holdOnOff, color) |
% |----------------------------------------------------------------------------------------------------------+
% | generations - pocet generacii v ktorych prebehne geneticky algoritmus                                    |
% | popSize - pocet jedincov v jednej generacii                                                              |
% | numOfGenes - pocet genov jedinca                                                                         |
% | holdOnOff - moznost zapnut(1) a vypnut(0) uchovavanie predoslych grafov                                  |
% | color - farba ciary na grafe                                                                             |
% +----------------------------------------------------------------------------------------------------------+

geneticAlgorithm(50, 5, 10, 1, 'red');
geneticAlgorithm(50, 10, 10, 1, 'green');
geneticAlgorithm(50, 100, 10, 1, 'blue');
geneticAlgorithm(50, 500, 10, 1, 'black');
geneticAlgorithm(50, 1000, 10, 1, 'yellow');

%geneticAlgorithm(5, 5, 10, 1, 'red');
%geneticAlgorithm(10, 5, 10, 1, 'green');
%geneticAlgorithm(20, 5, 10, 1, 'blue');
%geneticAlgorithm(30, 5, 10, 1, 'black');
%geneticAlgorithm(50, 5, 10, 1, 'yellow');

% Rastriginova funkcia
function [y] = rastrigin(tenVariables) 
    y = 100;
    for variable = tenVariables
        y = y + ((variable^2) - (10*cos(2*pi*variable)));
    end
end

% Hlavny algoritmus definovany ako funkcia pre lahke volanie s roznymi hodnotami
function geneticAlgorithm(generations, popSize, numOfGenes, holdOnOff, color) 
    
    % Ohranicenie argumentov
    xiMin = -5.12;
    xiMax = 5.12;
    
    % Nastavenie rozsahu vyberu a intenzity zmeny v genoch
    scope = [ones(1, numOfGenes)*xiMin; ones(1, numOfGenes)*xiMax];
    
    % Populacia s ktorou budeme pracovat
    population = genrpop(popSize, scope);
    grafFit = zeros(1, generations);
    
    % Generacne meniace sa hodnoty pre jedincov
    valuesPerSpecimen = (zeros(1,popSize));
    scope = [ones(1, numOfGenes)*xiMin*0.0000001; ones(1, numOfGenes)*xiMax*0.0000001];

    % Generacny cyklus
    for generation = 1 : 1 : generations
    
        % Hodnotenie jedincov
        for order = 1 : 1 : popSize
            valuesPerSpecimen(order) = rastrigin(population(order,:));
        end
    
        % Zaznam hodnot kazdu generaciu pre finalny graf
        grafFit(generation) = min(valuesPerSpecimen);
        
        % Selekcia jedincov
        population1 = selbest(population, valuesPerSpecimen, [1,1,1,1]);
        population2 = selsus(population, valuesPerSpecimen, (popSize - 4));
        
        % Krizenie a mutacia
        population2 = crossov(population2, 1, 0);
        population2 = mutx(population2, 0.1, scope);

        %Spojenie 2 populaci do finalnej
        population = [population1;population2];
  
    end
    
    % Vykreslenie grafu
    figure(1);
    plot(grafFit, color);
    xlabel('Generacie');
    ylabel('Hodnoty');
    title('Uloha 1');
    grid;
    if holdOnOff == 1
        hold on;
    else
        hold off;
        clear
        close all
        clc
    end
    
    %Volba a vypis najlepsieho riesenia
    best = selbest(population, valuesPerSpecimen, [1]);
    
    fprintf("========================================================================================================================================================================================\n");
    fprintf("Farba: %s\n", color);
    fprintf("Najnizsia dosiahnuta hodnota: %f\n", min(best));
    fprintf("----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    fprintf("Pre suradnice:\n");
    fprintf("a = %f, b = %f, c = %f, d = %f, e = %f, f = %f, g = %f, h = %f, i = %f, j = %f\n",best(1),best(2),best(3),best(4),best(5),best(6),best(7),best(8),best(9),best(10));
    fprintf("========================================================================================================================================================================================\n");
    fprintf("\n");
    fprintf("\n");

end

