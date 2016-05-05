function [ action_value ] = actionValueApprox(theta, state, action)
%UNTITLED2 Summary of this function goes here
%   TODO 1/state-feature or -state-feature?
global numThings
i = actionToEye(action)
action_value = 0;
for j=1:numThings
    action_value = action_value + 1/state(i,j) * theta(i,j);
end
end
