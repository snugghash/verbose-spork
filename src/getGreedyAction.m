function maxAction = getGreedyAction(obsState, theta)
maxValue = -Inf;
maxAction = 3; %TODO Made the default greedy action 3, so we know why it's spinning.
for j=1:3
    tmp = actionValueApprox(theta, obsState, j);
    if tmp>=maxValue % TODO: Should it be in absolute terms?
        maxValue = tmp;
        maxAction = j;
    end
end
end
