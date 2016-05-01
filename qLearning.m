function [ action ] = qLearning( obsState, position, lastReward )
%Qlearning Learning to select options and navigate, one step at a time.
% Arguments: Observed state, position, reward from last action.
% Overview: Options: --Explore --Go to fruit --Choose between fruit to go
% to.
% TODO: Everything
% Exploitation of multiple good things

% Actions: 0-Move forward, 1-Turn Right 45\deg, 2-Turn Left 45\deg, and
% 4-Turn back 180\deg
j=0;
epsilon = 0.1;
alpha = 0.3;
gamma = 0.9;

% Check if Q values are in workspace. Initialize otherwise.
if(exist('Q')==0)
    global Q;
    % Each of the possible states have action values
    Q = zeros((eyes*fov)^numThings,5); 
end

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
    % Explore
    % epsilon-greedy action selection
    [Max, action_t] = max(Q(stateIndex,:));
    % % % % % % % % if Max == 0
    % % % % % % % %     action_t = randi(4);
    % % % % % % % % end
    for i = 1:4
        if action_t ~= i
            j=j+1;
            remActions(j) = i;
        end
    end

    if normcdf(randn()) >= 1 - epsilon
        actionSelected = action_t;
    else 
        actionSelected = remActions( randi(3) );
    end
else
    % Collect good thing
end

% % Stochastic Action Selection (A_t)
% afterState = [stateIndex actionSelected];
% action = actionSelected;
% % % display(actionSelected);
% 
% % State Transition 
% j=0;
% for i = 1:4
%     if action ~= i
%         j=j+1;
%         remActions(j) = i;
%     end
% end
% 
% if normcdf(randn()) >= 0.9
%     newState_trans = state + takeAction(action);
% else 
%     action = remActions( randi(3) );
%     newState_trans = state + takeAction(action);
% end
% % % display(action);
% 
% % Reverting the action violations
% if ( (newState_trans(1) > 12 || newState_trans(1) < 1) ...
%         || (newState_trans(2) > 12 || newState_trans(2) < 1) )
%     newState_trans = state;
%     display('Action blocked')
% % % % %     action = 0;
% end
% 
% newState = newState_trans;
% 
% R = reward(newState(1), newState(2), variant);
% 
% % Action in newState - A_t+1 at new state S_t+1
% newStateIndex = getStateIndex(newState);
% % epsilon-greedy action selection
% [Max, action_t_1] = max(Q(newStateIndex,:));
% j=0;
% for i = 1:4
%     if action_t_1 ~= i
%     j=j+1;
%         remActions(j) = i;
%     end
% end
% if normcdf(randn()) >= 1 - epsilon
%     newActionSelected = action_t_1;
% else 
%     newActionSelected = remActions( randi(3) );
% end
% newAfterState = [newStateIndex newActionSelected];
% 
% 
% % Nomenclature [state(s) actionSelected(a) newState(s') newActionSelected(a') R]
% % Please note action at time t is 'actionSelected'
% if newState ~= state
%     
%     delta = R + gamma * Q(getStateIndex(newState), newActionSelected)...
%         - Q(getStateIndex(state), actionSelected);
%     
%     % Replacing Traces
%     E(getStateIndex(state), actionSelected) = 1;
%     
%     for s = 1:144
%         for a = 1:4
%             Q(s,a) = Q(s,a) + alpha * delta * E(s,a);
%             E(s,a) = gamma * lambda * E(s,a);
%         end
%     end

end
