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
global turnRate WALL previousState previousAction theta GOOD BAD eyes numThings dbg GAMMA blobsEaten turningActions onlyExplore;
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
% Get distance to closest good thing. [It explores only the closest good thing]
closestGoodDistance = GAMMA;
closestGoodDirection = 0;
stateClosest = GAMMA .* ones(eyes,numThings);
for i=1:eyes
    [minGood, ind] = min(obsState(i,GOOD,:));
    stateClosest(i,GOOD) = minGood;
    [minBad, ~] = min(obsState(i,BAD,:));
    stateClosest(i,BAD) = minBad;
    stateClosest(i,WALL) = obsState(i,WALL,1);

    if (minGood < closestGoodDistance)
        % TODO: this code can be optimized
        closestGoodDistance = obsState(i,GOOD,ind);
        closestGoodDirection = i;
    end

end
% If nothing good found,
if(closestGoodDirection == 0 || blobsEaten<1 || onlyExplore)
    % Explore (TODO Go to last known good thing)
    % Fixed policy: Straight until we hit wall, turn until we no longer face wall, keep
    % going.
    % turningActions stores the number of *turning actions* that are left
    % for us to do, in order point in the desired direction.

    if(turningActions>0)
        if(dbg)
            display('Exploring, turning.')
        end
        action = 2;
        turningActions = turningActions -1;

    elseif(stateClosest(round(eyes/2),WALL)<5) %TODO HARDCODED Distance to start turning.
        if(dbg)
            display('Exploring, starting turn.')
        end
        % Randomly choose an angle to turn between turnRate and 180-turnRate
        turningActions = randi(180/turnRate-1); %Adopted Suhas's change
        action = 2;
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
    action = getGreedyAction(stateClosest, theta);
end

%% Updating from observed reward
% If previousState exists, update it. % TODO:Check it again, second if cond.
if(isempty(previousState)==0)
    if any(stateClosest(:) ~= previousState(:))
        delta = lastReward + actionValueApprox(theta,stateClosest,action) - actionValueApprox(theta,previousState,previousAction);
        setOfSensors = actionToEye(previousAction);
        for i_counter=1:length(setOfSensors)
            [tmp j] = min(previousState(setOfSensors(i_counter),:));
            theta(setOfSensors(i_counter),j) = theta(setOfSensors(i_counter),j) + learningRate * delta * gradActionValue_wrtTheta(previousState,[setOfSensors(i_counter) j]);
        end
    end
end

%% TODO: @Suhas Please check the correctness of this change
previousState = stateClosest;
previousAction = action;

end

