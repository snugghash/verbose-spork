function [ obsEnv, actionSetForDir ] = observableEnv( fullEnv, pos, dirVec )
%UNTITLED2 Summary of this function goes here
%   Provides the observable environment to the bot based on its curr pos
%   (pos) and the direction its looking in(dirVec).
%   Format of obsEnv: (EYE,DISTANCE) TODO verify

global visibility angle eyes WALL GOOD BAD ballRadius turnRate amountOfConsumables numThings gridSize quiverPlot axPosition quiverSidePlot sideWings GAMMA;
turnRate = 45;
visibility = 5*ballRadius; % Arbitally chosen
angle = 135;
eyes = 9;
actions = 5;
GAMMA = 10000; % Large value instead of Inf. Inf resolves to uncomparable.

% Shifting origin of axes.
% Window of pos(coords) +/- (visibility + ballRadius)
relativePos = [fullEnv(2:end,1)-pos(1) fullEnv(2:end,2)-pos(2) fullEnv(2:end,3) fullEnv(2:end,4)];

% Relative position of things inside visible range, discarding outside.
% SelfNote : find is not required here! (as the arg is logical)
obsEnvSpace = relativePos(  (sum(abs(relativePos(:,1:2))<(visibility + ballRadius),2) == 2), :  );
% relativeDistance will yield exact result : Radial Distance 
% Agario uses a box hence use obsEnvSpace in future
% [New] Here we are having radial check for the relative distance
relativePosObs = [obsEnvSpace(:,1) obsEnvSpace(:,2)];
relativeDistance = sqrt(relativePosObs(:,1).^2 + relativePosObs(:,2).^2);
% These are the actual things that is seen by the agent. [In a radial sense equal in all directions]
obsEnvSpace = obsEnvSpace( (relativeDistance<(visibility + ballRadius)), : );
% Reconditioning the obsEnvSpace in the absolute coordinates
obsEnvSpace = [obsEnvSpace(:,1)+pos(1) obsEnvSpace(:,2)+pos(2) obsEnvSpace(:,3) obsEnvSpace(:,4)];

% Field of View
dirVecAngle = atand(dirVec(2)/dirVec(1));
for i = 1:eyes
    obsDirs(i) = dirVecAngle - ((eyes+1)/2 - i)*(angle/eyes);
end

% Things in the field of view within visibility
relativePosObs = [obsEnvSpace(:,1)-pos(1) obsEnvSpace(:,2)-pos(1)];
thetaRotation = atan2d(dirVec(2), dirVec(1));
rotationMatrix = [cosd(thetaRotation) -sind(thetaRotation); sind(thetaRotation) cosd(thetaRotation)];
rotatedAxesToTheCentreEye_RelativePos = relativePosObs * rotationMatrix; 
relativeAngle= atan2d(rotatedAxesToTheCentreEye_RelativePos(:,2), rotatedAxesToTheCentreEye_RelativePos(:,1));
obsEnvSpace = obsEnvSpace( (abs(relativeAngle)<(obsDirs(end)-thetaRotation)), :);



% Observing and assigning any blob and distance to it data
obsEnv = GAMMA.*ones(eyes,numThings); %TODO hardcoded
for line = 1:eyes
    % Check for intersection with WALL, (boundary a.t.m)
    % Perpendicular distance
    perpenDistanceX2 = gridSize - fullEnv(1,1);
    % Distance along direction vector
    % Corrected distances - (Remove later)
    % Changed: [cos(a) sin(a)][1;0] for top wall, similarly for the
    % right wall => [cos(a) sin(a)] = [fullEnv(1,3) fullEnv(1,4)] for
    % the middle sensor
    DistanceToRightWallAlongSensor = perpenDistanceX2/(sin(acos(abs(sind(obsDirs(line))*1))));
    perpenDistanceY2 = gridSize - fullEnv(1,2);
    DistanceToTopWallAlongSensor = perpenDistanceY2/(sin(acos(abs(cosd(obsDirs(line))*1))));
    if(DistanceToTopWallAlongSensor<DistanceToRightWallAlongSensor)
        if(DistanceToTopWallAlongSensor<visibility) 
            obsEnv(line, WALL) = DistanceToTopWallAlongSensor;
        end
    else
        if(DistanceToRightWallAlongSensor<visibility) 
            obsEnv(line, WALL) = DistanceToRightWallAlongSensor;
        end
    end
    % Number of consumables
    for i=1:size(obsEnvSpace,1)
        % Check for intersection with circle of consumables
        [xout,yout] = linecirc(tand(obsDirs(line)),0,obsEnvSpace(i,1)-pos(1),...
        obsEnvSpace(i,2)-pos(2),ballRadius); 
        if ~isnan(xout)
            % Intersection detected
            temp(1) = sqrt(xout(1)*xout(1) + yout(1)*yout(1));
            temp(2) = sqrt(xout(2)*xout(2) + yout(2)*yout(2));
            if temp(1)<=temp(2) % temp(1) is not necessarily smallest
                if temp(1)<=visibility
                    if(obsEnv(line, obsEnvSpace(i,3)) > temp(1))
                        obsEnv(line, obsEnvSpace(i,3)) = temp(1);
                    end
                end
            elseif temp(2) <= visibility
                    if(obsEnv(line, obsEnvSpace(i,3)) > temp(2))
                        obsEnv(line, obsEnvSpace(i,3)) = temp(2);
                    end
            end
        else
            % No intersection
            obsEnv(line, obsEnvSpace(i,3)) = GAMMA;
        end
    end
end

% Five actions that can be taken - middle 5
actionSetForDir = obsDirs((eyes+1)/2-(actions-1)/2 : (eyes+1)/2+(actions-1)/2 );

% TODO: Defining the obs environment
if(sideWings == 1)
        for i=1:eyes
            u = visibility * cosd(obsDirs(i));
            v = visibility * sind(obsDirs(i));
            set(quiverSidePlot(i), 'XData', fullEnv(1,1),...
            'YData',fullEnv(1,2),...
            'UData', u, 'VData', v);
        end
end

end

% TODO: Feel that its not setting the sector as the observable environment