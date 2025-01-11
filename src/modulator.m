% Modulator subsystem of the M-PAM transmitter
function bandpass_signal = modulator(baseband_signal, fc, Ts)

    % Initialize time vector
    t = (0:length(baseband_signal)-1) * Ts;
    
    % Take the signal to the frequency fc
    bandpass_signal = baseband_signal .* cos(2 * pi * fc * t);

end