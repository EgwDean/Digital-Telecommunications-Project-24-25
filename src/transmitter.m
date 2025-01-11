% M-PAM transmitter system
function bandpass_signal = transmitter(binary_sequence, M, fc, Rs, encoding)

    % Compute basic parameters
    Tsymbol = 1 / Rs;
    fs = 4 * fc;
    Ts = 1 / fs;

    % Map the binary sequence to symbols using M-PAM mapper
    symbols = mapper(binary_sequence, M, encoding);
    
    % Shape the symbols using M-PAM pulse shaper
    baseband_signal = pulse_shaper(symbols, Tsymbol, Ts);

    % Take the signal to frequency fc using M-PAM modulator
    bandpass_signal = modulator(baseband_signal, fc, Ts);

end