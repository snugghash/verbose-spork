dbg = str2num(input('Do you want to debug = ','s'));
% Generate Environment
EnvState = 0;
[EnvState, ~] = EnvironmentModel(EnvState, 1);

% Start the bot
pos = [1 1];
vec = [0 1];
vec = vec / norm(vec);
obsEnv = observableEnv(EnvState, pos, vec);
action = squareAgent(obsEnv, 0);
        
max_steps = 10000;
frame = 100;
steps = 0;
figure(1);
avgRewardPlot = plot(nan, 'b*');
hold on;
X = get(avgRewardPlot, 'XData');
Y = get(avgRewardPlot, 'YData');

if dbg == 1 
    display('In main: before while');
end
j=0;
while steps<=max_steps
    if dbg == 1 
        display(['Steps(Age): ' num2str(steps)]);
        display(['Action Taken: ' num2str(action)]);
        display(obsEnv);
    end
    avgReward = 0;
    for i=1:100
        obsEnv = observableEnv(EnvState, EnvState(1,[1 2]), EnvState(1,[3 4]));
        action = squareAgent(obsEnv);
        [EnvState, reward] = EnvironmentModel(EnvState, action);
        avgReward = avgReward+reward;
        steps = steps+1;
    end
    avgReward = avgReward/100;
    % To display all the previous points in the plot.
    j=j+1;
    temp1(j) = round(steps/100);
    temp2(j) = avgReward;
    figure(1);
    hold on;
    set(avgRewardPlot, 'XData', [X temp1], 'YData', [Y temp2]);
    drawnow
end
