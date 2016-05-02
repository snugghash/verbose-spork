function [ action_value ] = actionValueApprox(theta, obsState)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    action_value = [0 0 0 0];
    for i=1:eyes
        for j=1:numThings
            % Left turn action value
            if(i <= (angleOfVision-turnRate)/angleOfVision*eyes)
                action_value(3) = action_value + obsState(i,j) * theta(i,j);
            end
            action_value(1) = action_value + obsState(i,j) * theta(i,j);
            % Right turn action value
            if(i > eyes-(angleOfVision-turnRate)/angleOfVision*eyes)
                action_value(2) = action_value + obsState(i,j) * theta(i,j);
            end
        end
    end
    
end

