function grad = gradActionValue_wrtTheta(previousState,feature)
%Returns the gradient at the state
    global BAD;
    if BAD==feature(2)
        grad = 1/previousState(feature(1), feature(2))^2;
    else
        grad = 1/previousState(feature(1), feature(2));
        
end
