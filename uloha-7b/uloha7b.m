% +---------------------+
% | Radovan Krizanovsky | 
% +---------------------+
% |      Uloha 7 B      |
% +---------------------+

clear;
clc;
close all;

% nacitanie a zobrazenie fuzzy systemu
fuzzySystem = readfis('uloha7bFis.fis');
fuzzy(fuzzySystem);

% testovanie fuzzy systemu
useFuzzySystem(10, 1, fuzzySystem);
useFuzzySystem(30, 2, fuzzySystem);
useFuzzySystem(70, 5, fuzzySystem);
useFuzzySystem(100, 7, fuzzySystem);

function useFuzzySystem(znecistenie, mnozstvo, fs)
    fprintf("| znecistenie je: %d percent |", znecistenie);
    fprintf(" mnozstvo je: %dkg |", mnozstvo);
    fprintf(" cas je: %.1f min.", evalfis(fs, [znecistenie, mnozstvo]));
    fprintf("\n");
    fprintf("\n");
end