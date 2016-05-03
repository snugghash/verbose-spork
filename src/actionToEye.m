function [ i] = actionToEye( action )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global eyes
if(action == 1)
    i = round(eyes/2);
elseif(action == 3)
    i = (angleOfVision-turnRate)/angleOfVision*eyes;
elseif(action == 2)
    i = eyes-(angleOfVision-turnRate)/angleOfVision*eyes;
end
end

