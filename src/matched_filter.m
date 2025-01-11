% Matched filter subsystem of the M-PAM receiver
function symbols = matched_filter(baseband_signal, Tsymbol, Ts)

    % Compute the rectangular pulse as round(Tsymbol / Ts) samples
    number_of_samples = round(Tsymbol / Ts);
    amplitude = sqrt(2 / Tsymbol);
    pulse = amplitude * ones(1, number_of_samples); 
    
    % Perform matched filtering
    match_filtered_signal = conv(baseband_signal, pulse, 'same');
    
    % Recover the symbols (the corellation is higher at the middles of the intervals)
    symbol_indices = round(number_of_samples/2:number_of_samples:length(match_filtered_signal));
    symbols = match_filtered_signal(symbol_indices);

end