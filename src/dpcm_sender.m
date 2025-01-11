% DPCM Sender function
function [y, y_hat, a_hat, a] = dpcm_sender(x, p, N, min_value, max_value)
    
    % Compute the length of the input
    l = length(x);

    % Error handling
    if p > l
        error('The predictor order cannot be greater than the signal length.');
    end
        
    % Initialize signal vectors
    y = zeros(1, l);
    y_hat = zeros(1, l);
    y_prime = zeros(1, l);
    y_hat_prime = zeros(1, l);
    
    % Compute the coefficients
    a = predictor_coefficients(x, p);
    
    % Quantize the coefficients to send them to the receiver
    [aq, centers] = my_quantizer(a, 8, -2, 2);
    a_hat = centers(aq);
    
    % Perform the first p iterations for hard-coded y_prime
    for n = 1:p
        y_prime(n) = x(n);
        y(n) = x(n) - y_prime(n);
        [yq, centers] = my_quantizer(y(n), N, min_value, max_value);
        y_hat(n) = centers(yq);
        y_hat_prime(n) = y_prime(n) + y_hat(n);
    end
    
    % Perform the rest of the iterations
    for n = p + 1:l
        for i = 1:p
            y_prime(n) = y_prime(n) + a(i) * y_hat_prime(n - i);
        end
        y(n) = x(n) - y_prime(n);
        [yq, centers] = my_quantizer(y(n), N, min_value, max_value);
        y_hat(n) = centers(yq);
        y_hat_prime(n) = y_prime(n) + y_hat(n);
    end

end
