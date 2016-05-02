function maxAction = getGreedyAction(obsState, theta)
max = -Inf;
for j=1:3
    tmp = actionValueApprox(theta, obsState, j);
    if tmp>max
        max = tmp;
        maxAction = j;
    end
end
end