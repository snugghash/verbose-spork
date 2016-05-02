function [ action ] = qLearning( obsState, position, lastReward )
%Qlearning Learning to select options and navigate, one step at a time.
% Arguments: Observed state, position, reward from last action.
% Overview: Options: --Explore --Go to fruit --Choose between fruit to go
% to.
% TODO: Everything
% Exploitation of multiple good things

%% Pre computation

% Actions: 1-Move forward, 2-Turn Right 45\deg, 3-Turn Left 45\deg, and
% 4-Turn back 180\deg (NOT IMPLEMENTED)
global turnRate WALL previousState previousAction theta;
turnRate = 45;
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
% Get distance to closest good thing
closestGoodDistance = Inf;
closestGoodDirection = 0;
for i=1:eyes
    if(obsState(i) < closestGoodDistance)
        closestGoodDistance = obsState(i);
        closestGoodDirection = i;
    end
end
if(closestGoodDirection == 0)
    % Explore (TODO Go to last known good thing)
    % Fixed policy: Straight until we hit wall, turn until we no longer face wall, keep
    % going.
    if(obsState(5,WALL)<Inf)
        action = 1;
    end
else
    % Collect good thing
    actionSelected = getGreedyAction(obsState);
end

action = actionSelected;

%% Updating from observed reward
% If previousState exists, update it.
if(isempty(previousState)==0)
    if newState ~= state
        delta = lastReward + actionValueApprox(obsState,action) - actionValueApprox(previousState,previousAction);
        i = actionToEye(previousAction);
        [tmp j] = min(previousState(i,:));
        theta(i,j) = theta(i,j) + learningRate * delta * gradActionValue_wrtTheta(previousState,[i j]);
    end
end


%% Post computation
previousState = obsState;
previousAction = action;

end