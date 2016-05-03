% Generate Environment
EnvState = 0;
EnvState = EnvironmentModel(EnvState);

% Start the bot
pos = [1 1];
vec = [0 1];
vec = vec / norm(vec);
obsEnv = observableEnv(EnvState, pos, vec);
action = qLearning(obsEnv);
        
max_steps = 100000;
frame = 100;
steps = 0;
figure(1);
lHandle = line(nan, nan);
while steps<=max_steps
    avgReward = 0;
    for i=1:100
        obsEnv = observableEnv(EnvState, pos, vec);
        action = qLearning(obsEnv);
        [EnvState, reward] = EnvironmentModel(EnvState);
        avgReward = avgReward+reward;
        steps = steps+1;
    end
    avgReward = avgReward/100;
    X = get(lHandle, 'XData');
    Y = get(lHandle, 'YData');
    set(lHandle, 'XData', [X round(steps/100)], 'YData', [Y avgReward]);
    drawnow
end