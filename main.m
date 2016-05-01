% env state
% 
% env previous state

% Generate Environment
%EnvState = 0;
EnvState = EnvironmentModel(EnvState);

% Start the bot
pos = [1 1];
vec = [0 1];
vec = vec / norm(vec);

obsEnv = observableEnv(EnvState, pos, vec);
action = qLearning(obsEnv, pos);


