%UNTITLED3 Summary of this function goes here
%   TODO: Initialize all the global variables agent/environment parameters
%   here
global vec numThings GAMMA turnRate angle ballRadius objectRadius amountOfConsumables GOOD BAD WALL gridSize visibility eyes reward blobsEaten;

% Main
if isempty(vec)
    vec = [1 0];
end
% Environment Model
if isempty(gridSize)
    gridSize = 100;
end
if isempty(WALL)
    WALL = 1;
end
if isempty(GOOD)
    GOOD = 2;
end
if isempty(BAD)
    BAD = 3;
end
if isempty(ballRadius)
    ballRadius = 5;
end
if isempty(objectRadius)
    objectRadius = 5;
end
if isempty(numThings)
    numThings = 3; 
end
if isempty(amountOfConsumables)
    amountOfConsumables = 30;
end
if isempty(visibility)
    visibility = 5*ballRadius;
end
if isempty(eyes)
    eyes = 9;
end

% Observable Model
if isempty(turnRate)
    turnRate = 45;
end
if isempty(angle)
    angle = 135;
end
if isempty(GAMMA)
    GAMMA = 10000; % Large value instead of Inf. Inf resolves to uncomparable NaNs.
end
if isempty(reward)
    rreward = 0;
end
if isempty(blobsEaten)
    blobsEaten = 0;
end

% Used to be interactive
global dbg
if isempty(dbg)
    dbg = 0;
end
global wipeOut
if isempty(wipeOut)
    wipeOut = 1;
end
global moveSlow
if isempty(moveSlow)
    moveSlow = 0;
end
global sideWings
if isempty(sideWings)
    sideWings = 0;
end

