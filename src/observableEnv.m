function [ obsEnv, actionSetForDir ] = observableEnv( fullEnv, pos, dirVec )
%UNTITLED2 Summary of this function goes here
%   Provides the observable environment to the bot based on its curr pos
%   (pos) and the direction its looking in(dirVec).

global visibility angle eyes WALL GOOD BAD ballRadius turnRate amountOfConsumables;
turnRate = 45;
visibility = 5*ballRadius; % Arbitally chosen
angle = 135;
eyes = 9;
actions = 5;

% Field of View
dirVecAngle = atand(dirVec(2)/dirVec(1));
for i = 1:eyes
    obsDirs(i) = dirVecAngle - ((eyes+1)/2 - i)*(angle/eyes);
end

% Observing and assigning any blob and distance to it data
j=0;
for i=1:size(fullEnv(2:amountOfConsumables,:),1) % Number of consumables
    for line = 1:eyes
        % Check for intersection with circle of consumables
        [xout,yout] = linecirc(obsDirs(line),0,fullEnv(1+i,1)-pos(1),...
            fullEnv(1+i,2)-pos(2),ballRadius); 
        if ~isnan(xout)
            % Intersection detected
            temp(1) = sqrt(xout(1)*xout(1) + yout(1)*yout(1));
            temp(2) = sqrt(xout(2)*xout(2) + yout(2)*yout(2));
            if temp(1)<=visibility
                obsEnv(line, fullEnv(1+i,3)) = temp(1);
            elseif temp(2) <= visibility
                obsEnv(line, fullEnv(1+i,3)) = temp(2);
            end
        else
            % No intersection
            obsEnv(line, fullEnv(1+i,3)) = Inf;
        end
        j=j+1; 
    end
end

% Five actions that can be taken - middle 5
actionSetForDir = obsDirs((eyes+1)/2-(actions-1)/2 : (eyes+1)/2+(actions-1)/2 );

end
