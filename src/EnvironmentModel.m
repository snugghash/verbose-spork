function [ currentEnvState, reward ] = EnvironmentModel( prevEnvState, action )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global numThings ballRadius objectRadius amountOfConsumables GOOD BAD WALL positionPlot positionAgent quiverPlot quiverSidePlot gridSize visibility axPosition moveSlow eyes;

% Generate Grid % Grid size defined in main.m
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
visibility = 5*ballRadius;
eyes = 9;

reward = 0;
if prevEnvState == 0
    % 30 rand coordinates, half of them good.
    coords = randi(gridSize, amountOfConsumables,2);
    coords(amountOfConsumables/2+1:end,3) = BAD;
    coords(1:amountOfConsumables/2,3) = GOOD;
    coords(amountOfConsumables/2+1:end,4) = negR;
    coords(1:amountOfConsumables/2,4) = plusR;
    positionPlot = plot(axPosition,coords(1:amountOfConsumables/2,1),coords(1:amountOfConsumables/2,2),'g+', coords(amountOfConsumables/2+1:end,1),coords(amountOfConsumables/2+1:end,2),'r+');
    agentPosition = [round(gridSize/2) round(gridSize/2)];
    agentDirection = [1 0];
    
    title('Agent and environment');
    positionAgent = plot(axPosition, agentPosition(1),agentPosition(2),'b*');
        
    % Current Environment
    currentEnvState = [agentPosition agentDirection;
        coords;];
    
    u = visibility * currentEnvState(1,3);
    v = visibility * currentEnvState(1,4);
    quiverPlot = quiver(axPosition, currentEnvState(1,1),currentEnvState(1,2),u,v);
%     if(sideWings == 1)
%         for i = 1:eyes
% %             quiverSidePlot(i) = 
%         end
%     end
    
    return;
else
    % TODO: Should we use this instead of set()? Will it increase the
    % performance?
    positionPlot = plot(axPosition,prevEnvState(2:amountOfConsumables/2+1,1),prevEnvState(2:amountOfConsumables/2+1,2),'g+', prevEnvState(amountOfConsumables/2+2:end,1),prevEnvState(amountOfConsumables/2+2:end,2),'r+');
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
set(positionAgent, 'XData', currentEnvState(1,1), 'YData', currentEnvState(1,2),'MarkerEdgeColor', 'b');
u = visibility * currentEnvState(1,3);
v = visibility * currentEnvState(1,4);
set(quiverPlot, 'XData', currentEnvState(1,1),...
                'YData',currentEnvState(1,2),...
                'UData', u, 'VData', v);
if(moveSlow == 1)
    pause(0.1)
end
drawnow
end
