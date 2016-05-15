function [ action ] = squareAgent( obsStateBig, lastReward )
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
global turnRate WALL previousState previousAction theta GOOD BAD eyes numThings actions dbg GAMMA blobsEaten turningActions onlyExplore discountFactor learningRate;
j=0;
epsilon = 0.1;

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
obsState = GAMMA .* ones(eyes,numThings);
for i=1:eyes
    [minGood, ind] = min(obsStateBig(i,GOOD,:));
    obsState(i,GOOD) = minGood;
    [minBad, ~] = min(obsStateBig(i,BAD,:));
    obsState(i,BAD) = minBad;
    obsState(i,WALL) = obsStateBig(i,WALL,1);

    if (minGood < closestGoodDistance)
        % TODO: this code can be optimized
        closestGoodDistance = obsStateBig(i,GOOD,ind);
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

    elseif(obsState(round(eyes/2),WALL)<5) %TODO HARDCODED Distance to start turning.
        if(dbg)
            display('Exploring, starting turn.')
        end
        % Randomly choose an angle to turn between turnRate and 180-turnRate
        turningActions = randi(180/turnRate-2); % One turningAction used up now.
        action = 2;
    else
        if(dbg)
            display('Exploring, moving forward.')
        end
        action = 1;
    end
else
    % Collect good thing - \epsilon-Greedy
    greedyAction = getGreedyAction(obsState, theta);
    j=0;
    remActions = zeros(actions-1,1);
    for i = 1:actions
        if i ~= greedyAction
            j=j+1;
            remActions(j) = i;
        end
    end
    if normcdf(randn()) <= 1 - epsilon
        action = greedyAction;
        if(dbg)
            display('Exploiting')
        end
    else
        action = remActions( randi(actions-1) );
        if(dbg)
            display('Exploring epsilon')
        end
    end
end

%% Updating from observed reward
% If previousState exists, update it. % TODO:Check it again, second if cond.
if(isempty(previousState)==0)
    if any(obsState(:) ~= previousState(:))
        delta = lastReward + actionValueApprox(theta,obsState,action) - discountFactor*actionValueApprox(theta,previousState,previousAction);
        setOfSensors = actionToEye(previousAction);
        for i_counter=1:length(setOfSensors)
            [tmp j] = min(previousState(setOfSensors(i_counter),:));
            theta(setOfSensors(i_counter),j) = theta(setOfSensors(i_counter),j) + learningRate * delta * gradActionValue_wrtTheta(previousState,[setOfSensors(i_counter) j]);
            if dbg
                display(['Grad. action value: ',num2str(gradActionValue_wrtTheta(previousState,[setOfSensors(i_counter) j]))]);
                display(['Object type: ',num2str(j)]);
            end
        end
    end
end

previousState = obsState;
previousAction = action;

end

