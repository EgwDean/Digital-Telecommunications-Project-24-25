% Question 2)

% Create a binary sequence
binary_sequence = randi([0, 1], 1, 100000);

% Initialize the sender parameters
fc = 25e5;
Rs = 25e4;
M = [2, 8];
SNR = 0:2:20;

% Initialize BER matrix
BER = zeros(length(M) + 1, length(SNR));

% Compute BER for each M value using binary encoding
for i = 1:length(M)

    % Number of bits per symbol for current M
    bits_per_symbol = log2(M(i));

    % Pad the binary sequence with zeros if necessary
    padding_length = mod(-length(binary_sequence), bits_per_symbol);
    if padding_length > 0
        binary_sequence_padded = [binary_sequence, zeros(1, padding_length)];
    else
        binary_sequence_padded = binary_sequence;
    end

    % Loop through SNR values
    for j = 1:length(SNR)

        % Pass the binary sequence through the sender system
        bandpass_signal = transmitter(binary_sequence_padded, M(i), fc, Rs, 'binary');
        
        % Pass the bandpass signal through the channel
        noisy_signal = channel(bandpass_signal, SNR(j), M(i));
        
        % Pass the noisy signal through the receiver
        receiver_sequence = receiver(noisy_signal, M(i), fc, Rs, 'binary');
        
        % Compute the number of bit errors
        error_count = sum(binary_sequence_padded ~= receiver_sequence);
        
        % Compute the Bit Error Rate (BER)
        BER(i, j) = error_count / length(binary_sequence_padded);

    end
end

% Compute BER for M = 8 using grey encoding

% Number of bits per symbol for current M = 8
bits_per_symbol = log2(M(end));

% Pad the binary sequence with zeros if necessary
padding_length = mod(-length(binary_sequence), bits_per_symbol);
if padding_length > 0
    binary_sequence_padded = [binary_sequence, zeros(1, padding_length)];
else
    binary_sequence_padded = binary_sequence;
end

% Loop through SNR values
for j = 1:length(SNR)

    % Pass the binary sequence through the sender system
    bandpass_signal = transmitter(binary_sequence_padded, M(end), fc, Rs, 'grey');
        
    % Pass the bandpass signal through the channel
    noisy_signal = channel(bandpass_signal, SNR(j), M(end));
        
    % Pass the noisy signal through the receiver
    receiver_sequence = receiver(noisy_signal, M(end), fc, Rs, 'grey');
        
    % Compute the number of bit errors
    error_count = sum(binary_sequence_padded ~= receiver_sequence);
        
    % Compute the Bit Error Rate (BER)
    BER(end, j) = error_count / length(binary_sequence_padded);

end

% Plot the BER curves for all M values in logarithmic scale
figure;
for i = 1:length(M)
    semilogy(SNR, BER(i, :), '-o', 'DisplayName', sprintf('M = %d, binary', M(i)));
    hold on;
end
semilogy(SNR, BER(length(M) + 1, :), '-o', 'DisplayName', sprintf('M = %d, grey', M(end)));

% Finalize plot
xlabel('SNR (dB)');
ylabel('BER (logarithmic scale)');
title('BER in respect to SNR');
legend('show');
grid on;

% Question 3)

% Initialize SER matrix
SER = zeros(length(M), length(SNR));

% Compute SER for each M value using binary encoding
for i = 1:length(M)

    % Number of bits per symbol for current M
    bits_per_symbol = log2(M(i));

    % Pad the binary sequence with zeros if necessary
    padding_length = mod(-length(binary_sequence), bits_per_symbol);
    if padding_length > 0
        binary_sequence_padded = [binary_sequence, zeros(1, padding_length)];
    else
        binary_sequence_padded = binary_sequence;
    end

    % Group the binary sequence bits into symbols
    grouped_bits = reshape(binary_sequence_padded, bits_per_symbol, [])';

    % Loop through SNR values
    for j = 1:length(SNR)

        % Pass the binary sequence through the sender system
        bandpass_signal = transmitter(binary_sequence_padded, M(i), fc, Rs, 'binary');
        
        % Pass the bandpass signal through the channel
        noisy_signal = channel(bandpass_signal, SNR(j), M(i));
        
        % Pass the noisy signal through the receiver
        receiver_sequence = receiver(noisy_signal, M(i), fc, Rs, 'binary');

        % Group the receiver sequence bits into symbols
        grouped_received_bits = reshape(receiver_sequence, bits_per_symbol, [])';
        
        % Compute the number of symbol errors
        error_count = 0;
        for k = 1:size(grouped_bits, 1)  % Loop through all symbols
            if ~isequal(grouped_bits(k, :), grouped_received_bits(k, :))
                error_count = error_count + 1;
            end
        end
        
        % Compute the Symbol Error Rate (SER)
        SER(i, j) = error_count / size(grouped_bits, 1);  % Divide by number of symbols

    end
end

% Plot the SER curves for all M values in logarithmic scale
figure;
for i = 1:length(M)
    semilogy(SNR, SER(i, :), '-o', 'DisplayName', sprintf('M = %d, binary', M(i)));
    hold on;
end

% Finalize plot
xlabel('SNR (dB)');
ylabel('SER (logarithmic scale)');
title('SER in respect to SNR');
legend('show');
grid on;
