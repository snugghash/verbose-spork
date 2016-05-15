function [ currentEnvState, reward ] = EnvironmentModel( prevEnvState, action )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global numThings initAgentPosition initAgentDirection ballRadius objectRadius amountOfConsumables GOOD BAD WALL positionPlot positionAgent quiverPlot quiverSidePlot gridSize visibility axPosition moveSlow eyes blobsEaten goodReward badReward coords;

reward = 0;
if prevEnvState == 0
    % 30 rand coordinates, half of them good.
    if isempty(coords)
        coords = randi(gridSize, amountOfConsumables,2);
        coords(amountOfConsumables/2+1:end,3) = BAD;
        coords(1:amountOfConsumables/2,3) = GOOD;
        coords(amountOfConsumables/2+1:end,4) = badReward;
        coords(1:amountOfConsumables/2,4) = goodReward;
    end
    %display(coords);
    % Good and Bad should have diiferent plot handles, easier for setting
    % new consumables 1-Good and 2-Bad
    positionPlot(1) = plot(axPosition,coords(1:amountOfConsumables/2,1),coords(1:amountOfConsumables/2,2),'g+');
    positionPlot(2) = plot(axPosition,coords(amountOfConsumables/2+1:end,1),coords(amountOfConsumables/2+1:end,2),'r+');
    agentPosition = initAgentPosition;
    agentDirection = initAgentDirection;

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
    % Used 'set'. TODO: Test (Ensure hold is on)
    set(positionPlot(1), 'XData', prevEnvState(2:amountOfConsumables/2+1,1), 'YData', prevEnvState(2:amountOfConsumables/2+1,2),'MarkerEdgeColor', 'g');
    set(positionPlot(2), 'XData', prevEnvState(amountOfConsumables/2+2:end,1), 'YData', prevEnvState(amountOfConsumables/2+2:end,2),'MarkerEdgeColor', 'r');

end

% Update the state from last action
EnvState = getNextState(prevEnvState, action);
% Calculate reward, check for same position as consumables, replace it with
% random position consumable % TODO: blob eat contract. ballRadius * (1 or 2)
for i = 1:amountOfConsumables
    if norm( (EnvState(1+i,[1 2]) - EnvState(1,[1 2])), 2 ) <= ballRadius
        reward = EnvState(1+i,4);
        % Generate a consumable
        newblob = randi(gridSize, 1,2);
        EnvState(1+i,[1 2]) = newblob;
        blobsEaten = blobsEaten + 1;
        % TODO Check for new coords on the old ones... instant food.
    end
end
currentEnvState = EnvState;

% Update the plot of agent and environment to reflect current position
set(positionAgent, 'XData', currentEnvState(1,1), 'YData', currentEnvState(1,2),'MarkerEdgeColor', 'b');

% Remove later, is getting calculated/plotted twice
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
