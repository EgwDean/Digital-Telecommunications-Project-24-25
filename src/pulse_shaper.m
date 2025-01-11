% Pulse shaper subsystem of the M-PAM transmitter
function baseband_signal = pulse_shaper(symbols, Tsymbol, Ts)

    % Compute the rectangular pulse as round(Tsymbol / Ts) samples
    number_of_samples = round(Tsymbol / Ts);
    amplitude = sqrt(2 / Tsymbol);
    pulse = amplitude * ones(1, number_of_samples);

    % Make the symbols last as long as the pulse (zero padding in between samples)
    symbols_upsampled = upsample(symbols, length(pulse));

    % Convolve (multiply each symbol and then add) with the pulse
    baseband_signal = conv(symbols_upsampled, pulse, 'same');

end