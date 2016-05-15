function [ i] = actionToEye( action )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global eyes angleOfVision turnRate sensorOverlap;
if(action == 1)
    i = [(round(eyes/2)-floor(sensorOverlap/2)):(round(eyes/2)+floor(sensorOverlap/2))];
elseif(action == 3)
    %i = (angleOfVision-turnRate)/angleOfVision*eyes;
    i = [(eyes-sensorOverlap+1):eyes];
elseif(action == 2)
    %i = eyes-(angleOfVision-turnRate)/angleOfVision*eyes;
    i = [1:sensorOverlap];
end
end