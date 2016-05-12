function grad = gradActionValue_wrtTheta(previousState,feature)
%Returns the gradient at the state
    grad = 1./previousState(feature)
end