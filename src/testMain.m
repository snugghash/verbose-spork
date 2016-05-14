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

%% Only exploration
clear all
onlyExplore = 1;
dbg = 1;
sideWings = 0;
main

%% Main function to generate tests
function tests = testMain
tests = functiontests(localfunctions);
end

%% Test Functions
function testFunctionOne(testCase)
% Test specific code
end

function FunctionTwotest(testCase)
% Test specific code
end

%% Optional file fixtures
function setupOnce(testCase)  % do not change function name
% set a new path, for example
end

function teardownOnce(testCase)  % do not change function name
% change back to original path, for example
end

%% Optional fresh fixtures
function setup(testCase)  % do not change function name
% open a figure, for example
end

function teardown(testCase)  % do not change function name
% close figure, for example
end
