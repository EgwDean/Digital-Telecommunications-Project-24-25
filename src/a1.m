% Question i)

% Load the audio signal
[y, fs] = audioread('speech.wav');

% Transpose for correct dimensions
y = y';

% Initializing parameters
min_value = -1;
max_value = 1;
N = [2, 4, 8];

% Compute signal power
signal_power = mean(y.^2);

% Initialize MSE matrix
MSE = [];

figure
hold on

% Loop over each value of N
for i = 3:-1:1
    
    % Non Uniform Quantizer
    [xq, centers, D, lower_bound, upper_bound] = Lloyd_Max(y, N(i), min_value, max_value);
    quantized(i, :) = centers(xq);
    MSE(i, 1:length(D)) = D;
    for j = 1:length(D)
        % Compute the SQNR
        noise_power = D(j);
        SQNR(i, j) = 10 * log10(signal_power / noise_power);
    end

    % Plot the SQNR for the current N
    plot(SQNR(i, :), 'DisplayName', sprintf('N = %d bits', N(i)), 'LineWidth', 2);
end

% Customize the plot
xlabel('Number of Iterations');
ylabel('SQNR (dB)');
title('SQNR vs. Number of Iterations for Different N');
legend show;
grid on;
hold off;

% Question ii)

% Loop over each value of N
for i = 1:3
    
    % Uniform Quantizer
    [xq_u, centers_u] = my_quantizer(y, N(i), min_value, max_value);
    quantized_u(i, :) = centers_u(xq_u);
    
    % SQNR calculation
    noise_power_u = mean((y - quantized_u(i, :)).^2);
    signal_power_u = mean(y.^2);
    SQNR_u = 10 * log10(signal_power_u / noise_power_u);

    % MSE for later question
    MSE_u(i) = noise_power_u;

    row_sqnr = SQNR(i, :);
    non_zero_indices = find(row_sqnr ~= 0);
    % Get the last non-zero index
    last_non_zero_sqnr = row_sqnr(non_zero_indices(end));

    sprintf("N = %d bits. \n Uniform Quantizer: SQNR(dB) = %d \n" + ...
        " Non Uniform Quantizer SQNR(dB) = %d", N(i), SQNR_u, last_non_zero_sqnr)
end

% Question iii)

% For all values of N
for i = 1:3
    % Plot the signals side by side
    subplot(1, 3, 1);
    plot(y, 'r', 'LineWidth', 2);
    xlabel('Time');
    ylabel('Amplitude');
    title('Original Signal');
    grid on;
    
    subplot(1, 3, 2);
    plot(quantized_u(i, :), 'g', 'LineWidth', 2);
    xlabel('Time');
    ylabel('Amplitude');
    title('Uniform Quantizer');
    grid on;
    
    subplot(1, 3, 3);
    plot(quantized(i, :), 'b', 'LineWidth', 2);
    xlabel('Time');
    ylabel('Amplitude');
    title('Non Uniform Quantizer');
    grid on;
    
    sgtitle(sprintf('N = %d bits', N(i)));
   
    % Listen to the signals
    disp("Original Signal")
    sound(y, fs)
    pause(length(y) / fs)
    disp("Uniform Quantizer")
    sound(quantized_u(i, :))
    pause(length(quantized_u(i, :)) / fs)
    disp("Non Uniform Quantizer")
    sound(quantized(i, :))
    pause(length(quantized(i, :)) / fs)
end

% Question iv)

plot(N, MSE_u, 'r', 'LineWidth', 2);
hold on;
plot(N, MSE(:, end), 'b', 'LineWidth', 2);
hold off;
title('MSE of Uniform and Non Uniform Quantizers');
xlabel('N (Number of Bits)');
ylabel('MSE');
legend('Uniform', 'Non Uniform');
grid on;