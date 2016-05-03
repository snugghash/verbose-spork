function envState = getNextState(prevState, action)
envState = prevState;
if action == 1 % Forward
    envState(1,1) = prevState(1,1) + prevState(1,3);
    envState(1,2) = prevState(1,2) + prevState(1,4);
    if ~isValidState(envState)
        envState = prevState;
        return;
    end
elseif action==2 % Counter clockwise
    envState(1,3) = -prevState(1,4); %TODO 90\deg
    envState(1,4) = prevState(1,3);
elseif action==3 % Clockwise
    envState(1,3) = prevState(1,4);
    envState(1,4) = -prevState(1,3);
    
end
end