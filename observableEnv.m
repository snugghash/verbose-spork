function [ obsEnv ] = observableEnv( fullEnv, pos, dirVec )
%UNTITLED2 Summary of this function goes here
%   Provides the observable environment to the bot based on its curr pos
%   (pos) and the direction its looking in(dirVec).

ballR = 5;
fov = 5*ballR;
angle = 135;
eyes = 9;

% Field of View
dirVecAngle = atand(dirVec(2)/dirVec(1));
for i = 1:9
    obsDirs(i) = dirVecAngle - (5-i)*15;
end

fullEnv()

end

