% Computes the predictor coefficients by solving the Yule-Walker equations
function a = predictor_coefficients(x, p)

    % Use the built-in aryule function to solve Yule-Walker equations
    % Requires Singal Proccessing Toolbox
    [a_full, ~] = aryule(x, p);

    % Remove the leading 1 to get only the AR coefficients
    a = a_full(2:end);

    % Reverse the sign as aryule returns -a
    a = -a;

end
