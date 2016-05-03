% Generate Environment
EnvState = 0;
[EnvState, ~] = EnvironmentModel(EnvState, 1);

% Start the bot
pos = [1 1];
vec = [0 1];
vec = vec / norm(vec);
obsEnv = observableEnv(EnvState, pos, vec);
action = squareAgent(obsEnv, 0);
        
max_steps = 100000;
frame = 100;
steps = 0;
figure(1);
lHandle = line(nan, nan);
X = get(lHandle, 'XData');
Y = get(lHandle, 'YData');
while steps<=max_steps
    avgReward = 0;
    for i=1:100
        obsEnv = observableEnv(EnvState, EnvState(1,[1 2]), EnvState(1,[3 4]));
        action = squareAgent(obsEnv);
        [EnvState, reward] = EnvironmentModel(EnvState, action);
        avgReward = avgReward+reward;
        steps = steps+1;
    end
    avgReward = avgReward/100;
    set(lHandle, 'XData', [X round(steps/100)], 'YData', [Y avgReward]);
    drawnow
end