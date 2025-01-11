% M-PAM receiver system
function receiver_sequence = receiver(noisy_signal, M, fc, Rs, encoding)

    % Compute basic parameters
    Tsymbol = 1 / Rs;
    fs = 4 * fc;
    Ts = 1 / fs;
    
    % Return the signal to the baseband using M-PAM demodulator
    baseband_signal = demodulator(noisy_signal, fc, Ts);

    % Perform matched filtering using M-PAM matched filter
    symbols = matched_filter(baseband_signal, Tsymbol, Ts);

    % Detect the received symbols using M-PAM detector
    indices = detector(symbols, M);
    
    % Map the symbols back to binary values using M-PAM demapper
    receiver_sequence = demapper(indices, M, encoding);
    
end
