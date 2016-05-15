% This file can be used to resume the bot from the previous workspace
% (learning)

% Testing from previous workspace.
global dbg wipeOut theta positionAgent amountOfConsumables sideWings vec moveSlow gridSize axPosition axReward positionPlot quiverPlot quiverSidePlot eyes blobsEaten;
dbg = str2num(input('Do you want to debug = ','s'));
moveSlow = str2num(input('Do you want the agent to move slowly(Press 1 for yes) = ','s'));
sideWings = str2num(input('Do you want to sideWings displayed? (Press 1 for yes) ','s'));
initVariables;
%%%%%%%%%%%%%%%%%%%%%%
% Redefining the plots
% TODO: Check if plots are closed or not
axPosition = subplot(3,3,[1 2 3 4 5 6]);
axReward = subplot(3,3,[7 8 9]);
hold(axPosition,'on');
hold(axReward,'on');
positionAgent = plot(axPosition, EnvState(1,1),EnvState(1,2),'b*');
positionPlot(1) = plot(axPosition,0,0,'g+'); % Good consumable handle
positionPlot(2) = plot(axPosition,0,0,'r+'); % Bad consumable handle
quiverPlot = quiver(axPosition,50,50,1,0);
for i = 1:eyes
    quiverSidePlot(i) = quiver(axPosition, 0,0,0,0);
end
avgRewardPlot = plot(axReward, nan, 'b*');
X = get(avgRewardPlot, 'XData');
Y = get(avgRewardPlot, 'YData');
%%%%%%%%%%%%%%%%%%%%%%

if dbg == 1
    display(['Steps(Age): ' num2str(steps)]);
    display(['Action taken last step: ' num2str(action)]);
    display(obsEnv);
end

avgReward = 0;
for i=1:frame
    obsEnv = observableEnv(EnvState);
    action = squareAgent(obsEnv, reward);
    [EnvState, reward] = EnvironmentModel(EnvState, action);
    avgReward = avgReward+reward;
    steps = steps+1;
    if moveSlow && dbg
        display(obsEnv);
        display(reward);
        display(theta);
    end
end
avgReward = avgReward/frame;
% To display all the previous points in the plot.
j=j+1;
temp1(j) = round(steps/frame);
temp2(j) = avgReward;
set(avgRewardPlot, 'XData', [X temp1], 'YData', [Y temp2]);
hold on
drawnow