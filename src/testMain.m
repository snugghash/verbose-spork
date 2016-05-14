% Each test carries over the globals. So for testing main itself, need `clear all`
% NOTE, TODO: Setting parameters without clear all is pointless -- the way it's set up, the old variable rewrites the parameter you set.

%% Start from scratch
clear all % True wipe
main

%% scratch, debug
clear all
dbg = 1;
moveSlow = 1;
sideWings = 0;
main

%% scratch, debug, sidewings
clear all
dbg = 1;
moveSlow = 1;
sideWings = 1;
main

%% debug without moveSlow
clear all
dbg = 1;
main

%% debug with sidewings
clear all
dbg = 1;
sideWings = 1;
main

%% Use previous learned theta
main


