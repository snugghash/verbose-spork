initVariables

global sideWings currEnv moveSlow daydream gridSize visibility axPosition axReward positionPlot quiverPlot quiverSidePlot eyes blobsEaten avgRewardPlot;

% Setting up axes for the plots and hold 'on'
axPosition = subplot(3,3,[1 2 3 4 5 6]);
axReward = subplot(3,3,[7 8 9]);
hold(axPosition,'on');
hold(axReward,'on');

% Setting the game boundaries
xlimit = [0 gridSize];
ylimit = [0  gridSize];
xbox = xlimit([1 1 2 2 1]);
ybox = ylimit([1 2 2 1 1]);
boundaryPlot = plot(axPosition,xbox,ybox,'BLACK');

% Initializing the plots
positionPlot(1) = plot(axPosition,0,0); % Good consumable handle
positionPlot(2) = plot(axPosition,0,0); % Bad consumable handle
axes(axPosition);
axis([-visibility gridSize+visibility -visibility gridSize+visibility]);
quiverPlot = quiver(axPosition,50,50,1,0);
for i = 1:eyes
    quiverSidePlot(i) = quiver(axPosition, 0,0,0,0);
end
rewardPlot = plot(axReward, nan, 'g');
avgRewardPlot = plot(axReward, nan, 'b*');
X = get(avgRewardPlot, 'XData');
Y = get(avgRewardPlot, 'YData');

% Start the bot
[EnvState, ~] = EnvironmentModel(0, 1);
obsEnv = observableEnv(EnvState, 0);
action = squareAgent(obsEnv, 0);

steps = 1;

if dbg == 1
    display('In main: before while');
end
j = 0;
counter = 1;
avgR(counter) = 0;
clear R;
while steps<=max_steps
    if dbg == 1
        display(['Steps(Age): ' num2str(steps)]);
        display(['Action taken last step: ' num2str(action)]);
        %display(obsEnv); %More useful is the closest things, printed in squareAgent.m
    end
    avgRewardPerFrame = 0;
    R(counter) = 0;
    for i=1:frame
        [EnvState, reward] = EnvironmentModel(EnvState, action);
        currEnv = EnvState;
        obsEnv = observableEnv(EnvState, daydream);
        action = squareAgent(obsEnv, reward);
        avgRewardPerFrame = avgRewardPerFrame+reward;
        steps = steps+1;
        if steps>=max_steps
            break;
        end
        if moveSlow && dbg
            %display(obsEnv); %More useful is the closest things, printed in squareAgent.m
            display(reward);
        end
        counter = counter + 1;
        R(counter) = R(counter-1) + reward;
        avgR(counter) = ((counter-1)*avgR(counter-1) + reward)/counter;
        theta
    end
    avgRewardPerFrame = avgRewardPerFrame/frame;
    % To display all the previous points in the plot.
    j=j+1;
    temp1(j) = round(steps/frame);
    temp2(j) = avgRewardPerFrame;
    set(avgRewardPlot, 'XData', [X temp1], 'YData', [Y temp2]);
    set(rewardPlot, 'XData', 1/frame:1/frame:counter/frame, 'YData', R, 'LineStyle', '-', 'Color','g');
    hold on
    drawnow
end
% Average Reward Plot
figure(2);
plot(1:size(avgR,2), avgR);
