% +---------------------+
% | Radovan Krizanovsky | 
% +---------------------+
% |       Uloha 0       |
% +---------------------+

clc
close
clear

xp = 0;
numOfSteps = 0;

%Manualne vstupy
xp = input('pociatocny bod hladania: ');
while xp > 6 || xp < -6
    clc
    fprintf('bod musi byt vacsi rovny ako -6 a mensi rovny ako 6 \n');
    xp = input('pociatocny bod hladania: ');
end
clc

xkrok = input('krok hladania: ');
clc

%Priprava grafu
graphX = -6:0.1:6;

plot(graphX,graphY(graphX))
grid;
xlabel('X');
ylabel('Y');
title('uloha0');
hold;
clc

run = 1;

plot(xp,graphY(xp),'+g');

%Cyklus hladania globalneho minima
while run == 1
    
    %Nastavenia okolia bodu
    xs1 = xp - xkrok;
    xs2 = xp + xkrok;

    ys1 = graphY(xs1);
    ys2 = graphY(xs2);
    yp = graphY(xp);
    
    %Podmienky zastavenia a znacenia
    if ((ys1 > yp && ys2 > yp) || xkrok == 0)
        run = 0;
        plot(xp,graphY(xp),'*r');
    
    elseif ys1 < yp || ys2 < yp
        
        numOfSteps = numOfSteps + 1;

        if ys1 < ys2
            xp = xp - xkrok;
        else
            xp = xp + xkrok;
        end
        plot(xp,graphY(xp),'+g');
        
    end

end

%Finalny vypis
fprintf('==========================================\n');
fprintf('Suradnice minima: X:%f Y:%f\n',xp,yp);
fprintf('==========================================\n');
fprintf('Pocet krokov: %d\n',numOfSteps);
fprintf('==========================================\n');

%Implementacia funkcie
function [y] = graphY(x) 
 y=0.2*x.^4+0.2*x.^3-4*x.^2+10; 
end