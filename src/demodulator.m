% Mapper subsystem of the M-PAM receiver
function baseband_signal = demodulator(noisy_signal, fc, Ts)

    % Initialize time vector
    t = (0:length(noisy_signal)-1) * Ts; 

    % Return the signal to the baseband
    baseband_signal = noisy_signal .* cos(2 * pi * fc * t);

end