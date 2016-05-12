function [ obsEnv, actionSetForDir ] = observableEnv( fullEnv, pos, dirVec )
%UNTITLED2 Summary of this function goes here
%   Provides the observable environment to the bot based on its curr pos
%   (pos) and the direction its looking in(dirVec).
%   Format of obsEnv: (EYE,DISTANCE) TODO verify

global visibility angle eyes WALL GOOD BAD ballRadius turnRate amountOfConsumables numThings gridSize quiverPlot axPosition quiverSidePlot sideWings GAMMA;

actions = 5;


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
% [Now the quiver will function properly]-atan2d
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
obsEnvSpace = obsEnvSpace( (abs(relativeAngle)<(obsDirs(end)-thetaRotation)), :);

% Defining walls [L; T; R; B]
x0 = fullEnv(1,1);
y0 = fullEnv(1,2);
ei = fullEnv(1,3);
ej = fullEnv(1,4);
wallVector = [0 1;1 0; 0 1; 1 0];
perpenDistance = [fullEnv(1,1); gridSize-fullEnv(1,2); gridSize - fullEnv(1,1); fullEnv(1,1);];

% DistanceToWallAlongSensor = perpenDistance * (csc(acos(abs(sind(obsDirs*1)))));
DistanceToWallAlongSensor = [ perpenDistance(1)*csc(acos(abs(sind(obsDirs*1)))); perpenDistance(2)*(csc(acos(abs(cosd(obsDirs*1)))));  perpenDistance(3)*csc(acos(abs(sind(obsDirs*1)))); perpenDistance(4)*(csc(acos(abs(cosd(obsDirs*1)))));];

% pointsOfIntersectionwithWalls = [0 y0-x0*tand(obsDirs); ...
%     x0+(gridSize-y0)*cotd(obsDirs) gridSize;...
%     gridSize y0+tand(obsDirs)*(gridSize-x0); ...
%     x0-y0*cotd(obsDirs) 0];
dots = [(-x0*tand(obsDirs))*ej-x0*ei; ((gridSize-y0)*cotd(obsDirs))*ei+ej*(gridSize-y0); (gridSize-x0)*ei+(tand(obsDirs)*(gridSize-x0))*ej; (-y0*cotd(obsDirs))*ei+(-y0)*ej];
dots = (sign(dots)+1)/2;
% DistanceToWallAlongSensor in the field of view. Basically marking the
% wrong distances by Inf as dividing it by 0 in dots.
DistanceToWallAlongSensor = DistanceToWallAlongSensor ./ dots;

% Observing and assigning any blob and distance to it data
obsEnv = GAMMA.*ones(eyes,numThings,size(obsEnvSpace,1));
obsEnvNew = GAMMA.*ones(size(obsEnvSpace,1)+1, eyes+1);
% obsEnvNew(1,2:end) = wallDistanceofAllEyes;
% Assigning type of the blob
obsEnvNew(:,1) = [1; obsEnvSpace(:,3)];

for line = 1:eyes
    % Check for intersection with WALL, (boundary a.t.m)
    % Perpendicular distance
% %     perpenDistanceX2 = gridSize - fullEnv(1,1);
    % Distance along direction vector
    % Corrected distances - (Remove later)
    % Changed: [cos(a) sin(a)][1;0] for top wall, similarly for the
    % right wall => [cos(a) sin(a)] = [fullEnv(1,3) fullEnv(1,4)] for
    % the middle sensor
% %     DistanceToRightWallAlongSensor = perpenDistanceX2/(sin(acos(abs(sind(obsDirs(line))*1))));
% %     perpenDistanceY2 = gridSize - fullEnv(1,2);
% %     DistanceToTopWallAlongSensor = perpenDistanceY2/(sin(acos(abs(cosd(obsDirs(line))*1))));
    distance = DistanceToWallAlongSensor( (DistanceToWallAlongSensor(:,line)<Inf),line );

    if(size(distance) == 1)
        if(distance<visibility) 
            obsEnv(line, WALL,:) = distance;
            obsEnvNew(1,line+1) = distance;
        end
    else
        if(distance(1)<distance(2))
            if(distance(1)<visibility) 
                obsEnv(line, WALL,:) = distance(1);
                obsEnvNew(1,line+1) = distance(1);
            end
        else
            if(distance(2)<visibility) 
                obsEnv(line, WALL,:) = distance(2);
                obsEnvNew(1,line+1) = distance(2);
            end
        end
    end
    
    
% % %     if(DistanceToTopWallAlongSensor<DistanceToRightWallAlongSensor)
% % %         if(DistanceToTopWallAlongSensor<visibility) 
% % %             obsEnv(line, WALL) = DistanceToTopWallAlongSensor;
% % %         end
% % %     else
% % %         if(DistanceToRightWallAlongSensor<visibility) 
% % %             obsEnv(line, WALL) = DistanceToRightWallAlongSensor;
% % %         end
% % %     end
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
                    obsEnv(line, obsEnvSpace(i,3),i) = temp(1);
                    obsEnvNew(1+i,line) = temp(1);
                end
            elseif temp(2) <= visibility
                obsEnv(line, obsEnvSpace(i,3),i) = temp(2);
                obsEnvNew(1+i,line) = temp(2);
            end
%             This option is by default.
% % % %         else
% % % %             % No intersection
% % % %             obsEnv(line, obsEnvSpace(i,3)) = GAMMA;
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

end

% TODO: Feel that its not setting the sector as the observable environment
% [Resolved]