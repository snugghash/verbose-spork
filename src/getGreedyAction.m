function maxAction = getGreedyAction(obsState, theta)
maxValue = -Inf;
maxAction = 1;
for j=1:3
    tmp = actionValueApprox(theta, obsState, j);
    if tmp>=maxValue
        maxValue = tmp;
        maxAction = j;
    end
end
end
