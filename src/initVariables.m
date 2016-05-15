% Initializes the parameters, options and other required variables which have a *single*(or most used) default value each.
%   TODO: Initialize all the global variables agent/environment parameters
%   here

% Used to be interactive
%if exist('wipeOut')
    %clearvars -except dbg wipeOut %TODO remove if coming from previous theta. Add to options, like debug.
    % Doesn't clear globals, hence
%    clear all
%end
global dbg
if isempty(dbg)
    dbg = 0;
end
global moveSlow
if isempty(moveSlow)
    moveSlow = 0;
end
global sideWings
if isempty(sideWings)
    sideWings = 0;
end

global vec numThings GAMMA turnRate angle ballRadius objectRadius amountOfConsumables GOOD BAD WALL gridSize visibility eyes;

% Plots
if exist('dontcloseall')
else
    close all % To close figures
end

% Main
if isempty(vec)
    vec = [1 0];
end
global max_steps
if isempty(max_steps)
    max_steps = 10000;
end
global frame
if isempty(frame)
    frame = 100; % We display averages over this frame
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
    turnRate = 15;
end
if isempty(angle)
    angle = 135;
end
if isempty(GAMMA)
    GAMMA = 10000; % Large value instead of Inf. Inf resolves to uncomparable NaNs.
end

% Agent space
global reward
if isempty(reward)
    reward = 0;
end
global blobsEaten
if isempty(blobsEaten)
    blobsEaten = 0;
end
global onlyExplore
if isempty(onlyExplore)
  onlyExplore = 0;
end
global discountFactor
if isempty(discountFactor)
    discountFactor = 0.9;
end
global learningRate
if isempty(learningRate)
    learningRate = 0.3;
end
