% AWGN Channel
function noisy_signal = channel(bandpass_signal, SNR, M)

    % Compute the noise variance σ^2
    variance = 2 / (log2(M) * 10^(SNR / 10));

    % Generate Gaussian noise
    noise = sqrt(variance) * randn(1, length(bandpass_signal));

    % Add the noise to the signal
    noisy_signal = bandpass_signal + noise;
    
end