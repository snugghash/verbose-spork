function [  ] = init( )
%UNTITLED3 Summary of this function goes here
%   TODO: Initialize all the global variables agent/environment parameters
%   here
global vec
global numThings GAMMA turnRate angle ballRadius objectRadius amountOfConsumables GOOD BAD WALL gridSize visibility eyes ;

% Main
vec = [1 0];

% Environment Model
gridSize = 100;
WALL = 1;
GOOD = 2;
BAD = 3;
ballRadius = 5;
objectRadius = 5;
numThings = 3; 
amountOfConsumables = 30;
visibility = 5*ballRadius;
eyes = 9;

% Observable Model
turnRate = 45;
angle = 135;
GAMMA = 10000; % Large value instead of Inf. Inf resolves to uncomparable.


end

