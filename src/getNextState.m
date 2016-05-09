function envState = getNextState(prevState, action)
envState = prevState;
global turnRate;
if action == 1 % Forward
    envState(1,1) = prevState(1,1) + prevState(1,3);
    envState(1,2) = prevState(1,2) + prevState(1,4);
    if ~isValidState(envState)
        envState = prevState; % Should equate only the action row
        return;
    end
elseif action==2 % Counter clockwise
    envState(1,3) = cos(turnRate)*prevState(1,3); %TODO 90\deg
    envState(1,4) = sin(turnRate)*prevState(1,4);
elseif action==3 % Clockwise
    envState(1,3) = cos(turnRate)*prevState(1,3);
    envState(1,4) = -sin(turnRate)*prevState(1,4);
    
end
end