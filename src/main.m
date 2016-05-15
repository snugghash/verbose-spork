initVariables

global sideWings moveSlow gridSize visibility axPosition axReward positionPlot quiverPlot quiverSidePlot eyes blobsEaten avgRewardPlot;

% Setting up axes for the plots and hold 'on'
axPosition = subplot(3,3,[1 2 3 4 5 6]);
axReward = subplot(3,3,[7 8 9]);
hold(axPosition,'on');
hold(axReward,'on');

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
obsEnv = observableEnv(EnvState);
action = squareAgent(obsEnv, 0);

steps = 0;

if dbg == 1
    display('In main: before while');
end
j = 0;
counter = 1;
while steps<=max_steps
    if dbg == 1
        display(['Steps(Age): ' num2str(steps)]);
        display(['Action taken last step: ' num2str(action)]);
        display(obsEnv(:,:,1));
    end
    avgReward = 0;
    R(counter) = 0;
    for i=1:frame
        [EnvState, reward] = EnvironmentModel(EnvState, action);
        obsEnv = observableEnv(EnvState);
        action = squareAgent(obsEnv, reward);
        avgReward = avgReward+reward;
        steps = steps+1;
        if moveSlow && dbg
            display(obsEnv(:,:,1));
            display(reward);
        end
        counter = counter + 1;
        R(counter) = R(counter-1) + reward;
%         theta
    end
    avgReward = avgReward/frame;
    % To display all the previous points in the plot.
    j=j+1;
    temp1(j) = round(steps/frame);
    temp2(j) = avgReward;
    set(avgRewardPlot, 'XData', [X temp1], 'YData', [Y temp2]);
    set(rewardPlot, 'XData', 1/frame:1/frame:counter/frame, 'YData', R, 'LineStyle', '-', 'Color','g');
    hold on
    drawnow
end
