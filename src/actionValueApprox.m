function [ action_value ] = actionValueApprox(theta, state, action)
%UNTITLED2 Summary of this function goes here
%   TODO 1/state-feature or -state-feature?
global numThings GOOD BAD;
% Gets the sensor set corresponding to the action we want to evaulate.
i = actionToEye(action);
action_value = 0;
for tmp=1:length(i)
    for j=1:numThings
        %TODO Experimental feature set. Raises to second power the bad things, so it falls away faster.
        if j==BAD
            % Testing if negative here can make any difference.
            action_value = action_value + 1/state(i(tmp),j)^2*theta(i(tmp),j)/length(i);
        else
            action_value = action_value + 1/state(i(tmp),j)*theta(i(tmp),j)/length(i);
        end
    end
end
end
