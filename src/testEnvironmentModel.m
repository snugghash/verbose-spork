%% Inital, move forward one step
env = EnvironmentModel(0,0);
env2 = EnvironmentModel(env,1);
assert(all(logical(env(1,[1 2]) + [1 0] == env2(1,[1 2]))))

%% Inital, rotate counter-clockwise
env = EnvironmentModel(0,0);
env2 = EnvironmentModel(env,1);
assert(all(logical(env(1,[1 2]) + [1 0] == env2(1,[1 2]))))
