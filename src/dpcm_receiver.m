% DPCM Receiver function
function y_hat_prime = dpcm_receiver(y_hat, a_hat, p)

    % Compute the length of the input
    l = length(y_hat);

    % Error handling
    if p > l
        error('The predictor order cannot be greater than the signal length.');
    end

     % Initialize signal vectors
    y_prime = zeros(1, l);
    y_hat_prime = zeros(1, l);

    % Perform the first p iterations for hard-coded y_prime
    for n = 1:p
        y_prime(n) = y_hat(n);
        y_hat_prime(n) = y_prime(n);
    end
    
    % Perform the rest of the iterations
    for n = p + 1:l
        for i = 1:p
            y_prime(n) = y_prime(n) + a_hat(i) * y_hat_prime(n - i);
        end
        y_hat_prime(n) = y_prime(n) + y_hat(n);
    end

end