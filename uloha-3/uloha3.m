% +---------------------+
% | Radovan Krizanovsky | 
% +---------------------+
% |       Uloha 3       |
% +---------------------+

%==========================================================================
% Nastavenia
numOfGenes = 5;
popSize = 20;
generations = 6000;
amp = [5,5,5,5; 20,20,20,20];
hold on;
%close all
color = "red";
deathPenalty = 0;
degreePenalty = 0; 
differencePenalty = 1;
values = 1;
%==========================================================================

% Ohranicenie argumentov
xiMin = 0;
xiMax = 2000000;

% Nastavenie rozsahu vyberu a intenzity zmeny v genoch
scope = [ones(1, numOfGenes)*xiMin; ones(1, numOfGenes)*xiMax];

% Populacia s ktorou budeme pracovat
population = genrpop(popSize, scope);
grafFit = zeros(1, generations);

% Generacne meniace sa hodnoty pre jedincov
valuesPerSpecimen = (zeros(1,popSize));

% Generacny cyklus
for generation = 1 : 1 : generations

    % Hodnotenie jedincov
    for order = 1 : 1 : popSize
        valuesPerSpecimen(order) = value((population(order,:)),deathPenalty,degreePenalty,differencePenalty);
    end

    % Zaznam hodnot kazdu generaciu pre finalny graf
    grafFit(generation) = (-1*(min(valuesPerSpecimen)));
    scope = [ones(1, numOfGenes)*100000; ones(1, numOfGenes)*10000000];
    
    % Selekcia jedincov
    population1 = selbest(population, valuesPerSpecimen, [3,2,1]);
    population2 = selsus(population, valuesPerSpecimen, 4);
    population3 = selsus(population, valuesPerSpecimen, 4);
    population4 = selsus(population, valuesPerSpecimen, 6);

    % Mutovanie a krizenie populacie
    population1 = crossov(population1, 1, 0);

    population2 = crossov(population2, 2, 0);
    population2 = mutn(population2,0.8,amp,scope);
    population2 = mutx(population2,0.8,scope);

    population3 = crossov(population3, 3, 0);
    population3 = muta(population3, 0.9, [1,1,1,1,1,1,1,1,1,1], scope);

    population4 = crossov(population4, 4, 0);
    population4 = mutn(population4,0.8,amp,scope);
    population4 = mutx(population4,0.8,scope);

    % Finalna populacia pre danu generaciu
    population = [population1;population2;population3;population4];
    population = crossov(population,1,1);

    % Odstranenie zapornych cisel
    population = removeNegative(population);
    

end

% Grafy
best = selbest(population, valuesPerSpecimen, [1]);

if color == "no"
    plot(grafFit);
else
    plot(grafFit, color);
end

hold on;
grid;
xlabel("Generacia");
ylabel("Najvacsi vynos");
hold off;

if values == 1
    % Konzolovy vypis
    fprintf("------------------------------\n");
    fprintf("     Alokacia investicii      \n");
    fprintf("------------------------------\n");
    fprintf(" Bezne akcie:        %.0f€ \n", best(1));
    fprintf(" Preferovane akcie:  %.0f€ \n", best(2));
    fprintf(" Podnikove dlhopisy: %.0f€ \n", best(3));
    fprintf(" Statne dlhopisy:    %.0f€ \n", best(4));
    fprintf(" Uspory v banke:     %.0f€ \n",best(5));
    fprintf("------------------------------\n");
    fprintf(" Celkovy vynos:      %.0f€ \n", -valuesPerSpecimen(5));
    fprintf("------------------------------\n");
end

%Funkcia na hodnotenie jedincov (vratane penalizacie)
function [finalValue] = value(chromosone, deathPenalty, degreePenalty, differencePenalty)

    finalValue = 0;
    
    % Jednotlive hodnoty chromozonu
    x1 = chromosone(1);
    x2 = chromosone(2);
    x3 = chromosone(3);
    x4 = chromosone(4);
    x5 = chromosone(5);

    % Finalna suma v pomeroch a bez pokutovania
    finalValue = finalValue + (x1 * 0.04);
    finalValue = finalValue + (x2 * 0.07);
    finalValue = finalValue + (x3 * 0.11);
    finalValue = finalValue + (x4 * 0.06);
    finalValue = finalValue + (x5 * 0.05);

    % Hodnotenie splnenia podmienok
    p1 = 1;
    if ((x1+x2+x3+x4+x5) > 10000000)
        p1 = 0;
    end

    p2 = 1;
    if ((x1+x2) > 2500000)
        p2 = 0;
    end

    p3 = 1;
    if (((-x4)+x5) > 0)
        p3 = 0;
    end

    p4 = 1;
    if ((-0.5*x1-0.5*x2+0.5*x3+0.5*x4-0.5*x5) > 0)
        p4 = 0;
    end

    % Pokutovanie 
    if deathPenalty == 1
    
        if (p1+p2+p3+p4 ~= 4)
            finalValue = finalValue - 10000000;
        end
    end

    if degreePenalty == 1
    
        penalty = 10000000;
        mistakes = (4 - (p1+p2+p3+p4));

        finalValue = finalValue - (penalty * mistakes);
    end

    if differencePenalty == 1
    
        penalty = 0;

        if p1 == 0
            penalty = penalty + ((x1+x2+x3+x4+x5)-10000000);
        end

        if p2 == 0
            penalty = penalty + ((x1+x2)-2500000);
        end

        if p3 == 0
            penalty = penalty + ((-x4)+x5);
        end

        if p4 == 0
            penalty = penalty + ((-0.5*x1-0.5*x2+0.5*x3+0.5*x4-0.5*x5));
        end

        finalValue = finalValue - penalty;

    end

    % Inverzia kvoli minimalizacnemu algoritmu
    finalValue = -finalValue;

end

% Funkcia na odstranenie zapornych hodnot z populacie
function [pop] = removeNegative(population)

    pop = population;

    for line = 1 : 20
        
        for collum = 1 : 5

            if ((pop(line, collum)) < 0)
                pop(line, collum) = -1*(pop(line, collum));
            end
        end
    end
end


