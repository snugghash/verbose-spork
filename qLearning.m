function [ action ] = Qlearning( EnvState, pos, reward )
%Qlearning Learning the Q outta an env, one step at a time.

%   Actions: 0-No action, 1-Right, 2-Left, 3-Up and 4-Down

j=0;
epsilon = 0.1;
alpha = 0.3;
gamma = 0.9;
stateIndex = getStateIndex(state);
 
% epsilon-greedy action selection
[Max, action_t] = max(Q(stateIndex,:));
% % % % % % % % % % if Max == 0
% % % % % % % % % %     action_t = randi(4);
% % % % % % % % % % end
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

% Stochastic Action Selection (A_t)
afterState = [stateIndex actionSelected];
action = actionSelected;
display(actionSelected);

% State Transition 
j=0;
for i = 1:4
    if action ~= i
        j=j+1;
        remActions(j) = i;
    end
end

if normcdf(randn()) >= 0.9
    newState_trans = state + takeAction(action);
else 
    action = remActions( randi(3) );
    newState_trans = state + takeAction(action);
end
display(action);

% Reverting the action violations
if ( (newState_trans(1) > 12 || newState_trans(1) < 1) ...
        || (newState_trans(2) > 12 || newState_trans(2) < 1) )
    newState_trans = state;
    display('Action blocked')
% % % %     action = 0;
end

newState = newState_trans;

% Blowing the wind
% if flag_wind == 1
    if normcdf(randn()) <= 0.5 && flag_wind == 1
        % Wind blow towards East(Right) Action_Right = 1
        newState = newState_trans + takeAction(1);
        display('Wind is blowing.......................');
    end
% end

% Reverting the wind violations
if ( (newState(1) > 12 || newState(1) < 1) ...
        || (newState(2) > 12 || newState(2) < 1) )
    newState = newState_trans;
    display('Wind blocked')
% % % %     action = 0;
end

R = reward(newState(1), newState(2), variant);

% [state actionSelected newState R]
% Please note action at time t is 'actionSelected'
if newState ~= state
    Q(getStateIndex(state), actionSelected) = Q(getStateIndex(state), actionSelected)...
        + alpha * (R + gamma * max( Q(getStateIndex(newState), :) ) ...
        - Q(getStateIndex(state), actionSelected));
    
    
% %     display('Updated')
end

% % % % state = newState;


end
