function [ currentEnvState ] = EnvironmentModel( prevEnvState )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Generate Grid
grid = [1:1000,1:1000];
negR = -2;
plusR = 1;
ballR = 5;
fov = 5*ballR;
angle = 135;
eyes = 9;
% coords;

if prevEnvState == 0
    % 30 rand coordinates
    coords = randi(1000, 30,2);
    coords(:,3) = 0;
    coords(1:15,3) = 1;
    coords(:,4) = negR;
    coords(1:15,4) = plusR;
end

% Generate a virus or blob
newblob = randi(1000, 1,2);
newblobtype = randi(1,1);
if(newblobtype == 1) R = plusR; else R = negR; end

% Current Environment
currentEnvState = [coords; [newblob newblobtype R]];


end
