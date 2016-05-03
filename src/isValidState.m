function ans = isValidState (Env, state)
    if state(1,1)<0 || state(1,2)<0 || state(1,1)>gridSize || state(1,2)>gridSize
        ans = 0;
    else
        ans = 1;
    end
end