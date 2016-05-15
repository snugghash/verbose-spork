function [ obsState, actionSetForDir ] = observableEnv( fullEnv, pos, dirVec )
%UNTITLED2 Summary of this function goes here
%   Provides the observable environment to the bot based on its curr pos
%   (pos) and the direction its looking in(dirVec).
%   Format of obsEnv: (EYE,DISTANCE) TODO verify

global visibility angle eyes WALL GOOD BAD ballRadius turnRate amountOfConsumables numThings gridSize quiverPlot axPosition quiverSidePlot sideWings GAMMA;

actions = 5;

relativePos = [fullEnv(2:end,1)-pos(1) fullEnv(2:end,2)-pos(2) fullEnv(2:end,3) fullEnv(2:end,4)];

% Relative position of things inside visible range, discarding outside.
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
dirVecAngle = atan2d(dirVec(2),dirVec(1));
for i = 1:eyes
    obsDirs(i) = dirVecAngle - ((eyes+1)/2 - i)*(angle/eyes);
end

% Things in the field of view within visibility
relativePosObs = [obsEnvSpace(:,1)-pos(1) obsEnvSpace(:,2)-pos(1)];
thetaRotation = atan2d(dirVec(2), dirVec(1));
rotationMatrix = [cosd(thetaRotation) -sind(thetaRotation); sind(thetaRotation) cosd(thetaRotation)];
rotatedAxesToTheCentreEye_RelativePos = relativePosObs * rotationMatrix;
relativeAngle= atan2d(rotatedAxesToTheCentreEye_RelativePos(:,2), rotatedAxesToTheCentreEye_RelativePos(:,1));
obsEnvSpace = obsEnvSpace( (abs(relativeAngle)<(((eyes+1)/2 - 1)*(angle/eyes))), :); % Minor bug fixed.


% New definition for wall detection [foolproof]
xlimit = [0 gridSize];
ylimit = [0  gridSize];
xbox = xlimit([1 1 2 2 1]);
ybox = ylimit([1 2 2 1 1]);
% mapshow(xbox,ybox,'DisplayType','polygon','LineStyle','none')
wingDirVec = [cosd(obsDirs') sind(obsDirs')];
for line = 1:eyes
    pos1(line,:) = pos + wingDirVec(line,:) * visibility;

    % Define and display a two-part polyline
    x = [pos(1) pos1(line,1)'];
    y = [pos(2) pos1(line,2)'];
%     mapshow(x,y,'Marker','+')

    % Intersect the polyline with the rectangle
    [xi, yi] = polyxpoly(x, y, xbox, ybox);
%     mapshow(xi,yi,'DisplayType','point','Marker','o')

    % Distance to the wall along the sensor
    if ~isempty(xi)
        distance(line) = norm( [xi-pos(1) yi-pos(2)] ,2);
    else
        distance(line) = GAMMA;
    end
end

% Observing and assigning any blob and distance to it data. One extra copy
% is created in case it becomes null.
obsEnv = GAMMA.*ones(eyes,numThings,size(obsEnvSpace,1)+1);

for line = 1:eyes
    % Assigning the min distance if within visibility
    obsEnv(line, WALL,:) = distance(line);

    % Number of consumables
    for i=1:size(obsEnvSpace,1)
        % Check for intersection with circle of consumables
        [xout,yout] = linecirc(tand(obsDirs(line)),0,obsEnvSpace(i,1)-pos(1),...
            obsEnvSpace(i,2)-pos(2),ballRadius);
        if ~isnan(xout)
            % Intersection detected
            temp(1) = sqrt(xout(1)*xout(1) + yout(1)*yout(1));
            temp(2) = sqrt(xout(2)*xout(2) + yout(2)*yout(2));
            if min(temp)<=visibility

                obsEnv(line, obsEnvSpace(i,3),i) = min(temp);
                % obsEnvNew(1+i,line) = temp(1);
            end
        end
    end
end

% Five actions that can be taken - middle 5
actionSetForDir = obsDirs((eyes+1)/2-(actions-1)/2 : (eyes+1)/2+(actions-1)/2 );

% TODO: Defining the obs environment here
if(sideWings == 1)
    for i=1:eyes
        u = visibility * cosd(obsDirs(i));
        v = visibility * sind(obsDirs(i));
        set(quiverSidePlot(i), 'XData', fullEnv(1,1),...
        'YData',fullEnv(1,2),...
        'UData', u, 'VData', v);
    end
end

obsStateBig = obsEnv;
obsState = GAMMA .* ones(eyes,numThings);
for i=1:eyes
    [minGood, ~] = min(obsStateBig(i,GOOD,:));
    obsState(i,GOOD) = minGood;
    [minBad, ~] = min(obsStateBig(i,BAD,:));
    obsState(i,BAD) = minBad;
    obsState(i,WALL) = obsStateBig(i,WALL,1);
end

end
