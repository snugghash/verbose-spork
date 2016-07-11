function ansCheck = isValidState (state)
    global gridSize;
    if state(1,1)<0 || state(1,2)<0 || state(1,1)>gridSize || state(1,2)>gridSize
        ansCheck = 0;
    else
        ansCheck = 1;
    end
end