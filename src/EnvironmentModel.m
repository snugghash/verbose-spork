function [ currentEnvState, reward ] = EnvironmentModel( prevEnvState, action )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global numThings ballRadius objectRadius amountOfConsumables GOOD BAD WALL positionPlot gridSize visibility;
% Generate Grid
gridSize = 100;
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
    coords = randi(gridSize, amountOfConsumables,2);
    coords(amountOfConsumables/2+1:end,3) = BAD;
    coords(1:amountOfConsumables/2,3) = GOOD;
    coords(amountOfConsumables/2+1:end,4) = negR;
    coords(1:amountOfConsumables/2,4) = plusR;
    figure(2);
    positionPlot = plot(coords(1:amountOfConsumables/2,1),coords(1:amountOfConsumables/2,2),'g+', coords(amountOfConsumables/2+1:end,1),coords(amountOfConsumables/2+1:end,2),'r+');
    hold on;
    agentPosition = [gridSize/2 gridSize/2];
    agentDirection = [1 0];
    figure(2);
    title('Agent and environment');
    plot(agentPosition(1),agentPosition(2),'b*');
    hold on;
    
    % Current Environment
    currentEnvState = [agentPosition agentDirection;
        coords;];
    %hold off;
    return;
else
    figure(2);
    positionPlot = plot(prevEnvState(2:amountOfConsumables/2+1,1),prevEnvState(2:amountOfConsumables/2+1,2),'g+', prevEnvState(amountOfConsumables/2+2:end,1),prevEnvState(amountOfConsumables/2+2:end,2),'r+');
    hold on;
end

% Update the state from last action
EnvState = getNextState(prevEnvState, action);
% Calculate reward, check for same position as consumables, replace it with
% random position consumable
for i = 1:amountOfConsumables
    if EnvState(1+i,[1 2]) == EnvState(1,[1 2])
        reward = EnvState(1+i,4);
        % Generate a consumable
        newblob = randi(gridSize, 1,2);
        EnvState(1+i,[1 2]) = newblob;
    end
end
currentEnvState = EnvState;

% Update the plot of agent and environment to reflect current position
figure(2);
hold on;
set(positionPlot, 'XData', currentEnvState(1,1), 'YData', currentEnvState(1,2),'MarkerEdgeColor', 'b');
u = currentEnvState(1,1) + visibility * currentEnvState(1,3);
v = currentEnvState(1,2) + visibility * currentEnvState(1,4);
quiver(currentEnvState(1,1),currentEnvState(1,2),u,v)
drawnow
end
