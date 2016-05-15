%Random behaviour tests to check learned policy's fitness in solving problem.

%% GOOD thing, straight ahead.
clear all
amountOfConsumables = 2;
initVariables;
global coords
coords = [60 50 GOOD 1; 10 50 BAD -2];
dbg = 1;
moveSlow = 1;
main

%% GOOD thing, to the left.

%% GOOD thing, to the right.

%% BAD thing, straight ahead.

%% BAD thing, to the left.

%% BAD thing, to the right.

%% GOOD___BAD
clear all
amountOfConsumables = 2;
initVariables;
global coords
coords = [60 50 GOOD 1; 70 50 BAD -2];
dbg = 1;
moveSlow = 1;
main

%% BAD___GOOD

%% BAD___GOOD___BAD

%% GOOD___BAD___BAD
clear all
amountOfConsumables = 2;
initVariables;
global coords
coords = [60 50 GOOD 1; 70 50 BAD -2; 80 50 BAD -2];
dbg = 1;
moveSlow = 1;
main

