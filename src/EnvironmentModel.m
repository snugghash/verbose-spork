function [ currentEnvState, reward ] = EnvironmentModel( prevEnvState, action )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Generate Grid
gridSize = 100;
%grid = [1:gridSize,1:gridSize];
global numThings ballRadius objectRadius amountOfConsumables GOOD BAD WALL positionPlot;
WALL = 1;
GOOD = 2;
BAD = 3;
negR = -2;
plusR = 1;
ballRadius = 5;
objectRadius = 5;
numThings = 2; % No walls
amountOfConsumables = 30;

reward = 0;
if prevEnvState == 0
    % 30 rand coordinates, half of them good.
    coords = randi(100, amountOfConsumables,2);
    coords(amountOfConsumables/2+1:end,3) = BAD;
    coords(1:amountOfConsumables/2,3) = GOOD;
    coords(amountOfConsumables/2+1:end,4) = negR;
    coords(1:amountOfConsumables/2,4) = plusR;
    positionPlot = plot(coords(1:amountOfConsumables/2,1),coords(1:amountOfConsumables/2,2),'g+', coords(amountOfConsumables/2+1:end,1),coords(amountOfConsumables/2+1:end,2),'r+');
    hold on;
    agentPosition = [1 1];
    agentDirection = [1 0];
    plot(agentPosition(1,[1 2]),'b*');
    
    % Current Environment
    currentEnvState = [agentPosition agentDirection;
        coords;];
    reward = 0;
    return;
end

% Update the state from last action
EnvState = getNextState(prevEnvState, action);
% Calculate reward, check for same position as consumables, replace it with
% random position consumable
for i = 1:amountOfConsumables
    if EnvState(1+i,[1 2]) == EnvState(1,[1 2])
        reward = EnvState(1+i,4);
        % Generate a consumable
        newblob = randi(1000, 1,2);
        EnvState(1+i,[1 2]) = newblob;
    end
end
currentEnvState = EnvState;
set(positionPlot, 'XData', currentEnvState(1,1), 'YData', currentEnvState(1,2));
drawnow
end
