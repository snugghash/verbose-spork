% env state
% 
% env previous state

% Generate Environment
%EnvState = 0;
EnvState = EnvironmentModel(EnvState);

% Start the bot
pos = [1 1];
vec = [randn(1) randn(1)];
vec = vec / norm(vec);

%observableEnv = 
action = Qlearning(EnvState, pos);

