function [ i] = actionToEye( action )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global eyes angleOfVision turnRate;
if(action == 1)
    i = round(eyes/2);
elseif(action == 3)
    %i = (angleOfVision-turnRate)/angleOfVision*eyes;
    i = [round(eyes/2)+1:eyes]
elseif(action == 2)
    %i = eyes-(angleOfVision-turnRate)/angleOfVision*eyes;
    i = [1:round(eyes/2)-1]
end
end

