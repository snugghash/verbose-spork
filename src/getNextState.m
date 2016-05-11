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
    envState(1,3) = ( prevState(1,3)*cosd(turnRate) - prevState(1,4)*sind(turnRate) );
    envState(1,4) = ( prevState(1,3)*sind(turnRate) + prevState(1,4)*cosd(turnRate) );
elseif action==3 % Clockwise
    envState(1,3) = ( prevState(1,3)*cosd(turnRate) + prevState(1,4)*sind(turnRate) );
    envState(1,4) = ( - prevState(1,3)*sind(turnRate) + prevState(1,4)*cosd(turnRate) );    
end
end