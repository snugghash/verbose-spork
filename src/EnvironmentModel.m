function [ currentEnvState ] = EnvironmentModel( prevEnvState, action )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Generate Grid
gridSize = 100;
grid = [1:gridSize,1:gridSize];
global numThings ballRadius objectRadius;
negR = -2;
plusR = 1;
ballRadius = 5;
objectRadius = 5;
numThings = 2; % No walls
coords = [];
amountOfConsumables = 30;


if prevEnvState == 0
    % 30 rand coordinates, half of them good.
    coords = randi(100, amountOfConsumables,2);
    coords(amountOfConsumables/2+1:end,3) = 0;
    coords(1:amountOfConsumables/2,3) = 1;
    coords(amountOfConsumables/2+1:end,4) = negR;
    coords(1:amountOfConsumables/2,4) = plusR;
    plot(coords(1:amountOfConsumables/2,1),coords(1:amountOfConsumables/2,2),'g+', coords(amountOfConsumables/2+1:end,1),coords(amountOfConsumables/2+1:end,2),'r+');
    agentPosition = [1 1];
    agentDirection = [1;0];
    plot(agentPosition(1),'b*');
end

% Update the satte fomr last action
EnvState = getNextState(prevEnvState, action);
% Calculate reward
for i = 1:amountOfConsumables
    if EnvState(1+i,[1 2]) == EnvState(1,[1 2]) && EnvState(1+i,[1 1]) == EnvState(1,[1 1]);
        reward = EnvState(1+i,4);
        % Generate a consumable
        newblob = randi(1000, 1,2);
        EnvState(1+i,[1 2]) = newblob;        
    end
end

% Current Environment
currentEnvState = [agentPosition agentDirection;
    coords; [newblob newblobtype R]];

end
