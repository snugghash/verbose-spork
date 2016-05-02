function [ obsEnv, actionSetForDir ] = observableEnv( fullEnv, pos, dirVec )
%UNTITLED2 Summary of this function goes here
%   Provides the observable environment to the bot based on its curr pos
%   (pos) and the direction its looking in(dirVec).

ballR = 5;
global fov angle eyes WALL GOOD BAD;
WALL = 1;
GOOD = 2;
BAD = 3;
visibility = 5*ballR; % Arbitally chosen
angle = 135;
eyes = 9;
actions = 5;

% Field of View
dirVecAngle = atand(dirVec(2)/dirVec(1));
for i = 1:eyes
    obsDirs(i) = dirVecAngle - ((eyes+1)/2-i)*(angle/eyes);
end

% Observing and assigning any blob and distance to it data
j=0;
for i=1:size(obsEnv,2)
    for line = 1:eyes
        [xout,yout] = linecirc(obsDirs(line),0,obsEnv(i,1)-pos(1),...
            obsEnv(i,2)-pos(2),ballR);
        
        if ~isnan(xout)
            temp = sqrt(xout*xout, yout*yout);
            if temp(1)<=visibility
                distance(line) = temp(1);
                obsEnv(j) = obsEnv(i);
            else
                distance(line) = temp(2);
                obsEnv(j) = obsEnv(i);
            end
        else
            distance(line) = -1;
        end
            
          j=j+1; 
    end
    
end
    

% Five actions that can be taken - middle 5
actionSetForDir = obsDirs((eyes+1)/2-(actions-1)/2 : (eyes+1)/2+(actions-1)/2 );




end

