function [ action ] = squareAgent( obsState, lastReward )
%Qlearning Learning to select options and navigate, one step at a time.
% Arguments: Observed state, position, reward from last action.
% Overview: Options: --Explore --Go to fruit --Choose between fruit to go
% to.
% 
% State is a matrix with 1st dimension being the sensors, and second is
% the object type.
%
% TODO
% Exploitation of multiple good things
% Good exploration/exploitation

%%
% Actions: 1-Move forward, 2-Turn anticlockwise by turnRate\deg, 
% 3-Turn clockwise by turnRate\deg, and 4-Turn 180\deg (NOT IMPLEMENTED)
global turnRate WALL previousState previousAction theta GOOD BAD eyes numThings dbg;
j=0;
epsilon = 0.1;
learningRate = 0.3;
discountFactor = 0.9;

% Check if theta values are in workspace. Initialize otherwise.
if(isempty(theta))
    % Each of the possible states have action values
    theta = zeros(eyes,numThings);
end

%% Selecting next action
% Exploration-exploitation policy:
% Get distance to closest good thing. 
closestGoodDistance = Inf;
closestGoodDirection = 0;
for i=1:eyes
    if(obsState(i,GOOD) < closestGoodDistance)
        closestGoodDistance = obsState(i,GOOD);
        closestGoodDirection = i;
    end
end
% If nothing good found,
if(closestGoodDirection == 0)
    % Explore (TODO Go to last known good thing)
    % Fixed policy: Straight until we hit wall, turn until we no longer face wall, keep
    % going.
    % turningActions stores the number of *turning actions* that are left for us to do, in order point in the desired direction.
    global turningActions;
    
    if(turningActions>0) 
        if(dbg)
            display('Exploring, turning.')
        end
        action = 2; 
        turningActions = turningActions -1;
    %elseif(obsState(5,WALL)<5) %TODO Distance to start turning.
    %    if(dbg)
    %        display('Exploring, starting turn.')
    %    end
    %    % Randomly choose an angle to turn between turnRate and 180
    %    turningActions = randi(3); %TODO
    %    action = 2;
    else 
        if(dbg)
            display('Exploring, moving forward.')
        end
        action = 1;
    end
else
    if(dbg)
        display('Exploiting')
    end
    % Collect good thing
    action = getGreedyAction(obsState, theta);
end

%% Updating from observed reward
% If previousState exists, update it.
if(isempty(previousState)==0)
    if obsState ~= previousState
        delta = lastReward + actionValueApprox(obsState,action) - actionValueApprox(previousState,previousAction);
        i = actionToEye(previousAction);
        [tmp j] = min(previousState(i,:));
        theta(i,j) = theta(i,j) + learningRate * delta * gradActionValue_wrtTheta(previousState,[i j]);
    end
end

%%
previousState = obsState;
previousAction = action;

end

