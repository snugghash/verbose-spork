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
avgRewardPlot = plot(nan);
hold on;
X = get(avgRewardPlot, 'XData');
Y = get(avgRewardPlot, 'YData');

if dbg == 1 
    display('In main: becclearfore while');
end

while steps<=max_steps
    if dbg == 1 
        display(steps);
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
    set(avgRewardPlot, 'XData', [X round(steps/100)], 'YData', [Y avgReward]);
    drawnow
end