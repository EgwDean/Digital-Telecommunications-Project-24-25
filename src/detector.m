% Detector subsystem of the M-PAM receiver
function indices = detector(symbols, M)

    % Compute the amplitude scaling factor A
    A = sqrt(3 / (M^2 - 1));

    % Map the amplitudes to the nearest M-PAM levels
    amplitudes = A * (-(M-1):2:(M-1));

    % Initialize a vector to store the indices of the nearest amplitudes
    indices = zeros(size(symbols));
    
    % Loop through each symbol in symbols received
    for i = 1:length(symbols)

        % Calculate the absolute difference between the current symbol and all amplitudes
        differences = abs(symbols(i) - amplitudes);
        
        % Find the index of the amplitude with the smallest difference
        [~, indices(i)] = min(differences);
    end
    
    % Adjust the indices to start from 0
    indices = indices - 1;

end