function [ newObsState, reward ] = summonNewObsStateForUpdating( action )
%UNTITLED5 Summary of this function goes here
%   Cleanly get new state params without updating anything on the game board.
 
global amountOfConsumables ballRadius eyes GOOD BAD WALL currEnv GAMMA numThings

newEnvState = getNextState(currEnv, action);
% Calculate reward, check for same position as consumables, replace it with
% random position consumable % TODO: blob eat contract. ballRadius * (1 or 2)
for i = 1:amountOfConsumables
    if norm( (newEnvState(1+i,[1 2]) - newEnvState(1,[1 2])), 2 ) <= ballRadius
        reward = newEnvState(1+i,4);
    else
        reward = 0;
    end
end
% Daydream is 1 => We are just calculating the next state ahead of time.
[ newObsStateBig, ~ ] = observableEnv( newEnvState, 1 );

newObsState = GAMMA .* ones(eyes,numThings);
for i=1:eyes
    newObsState(i,GOOD) = min(newObsStateBig(i,GOOD,:));
    newObsState(i,BAD) = min(newObsStateBig(i,BAD,:));
    newObsState(i,WALL) = newObsStateBig(i,WALL,1);
end

end
