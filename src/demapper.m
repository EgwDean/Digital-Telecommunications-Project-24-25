% Demapper subsystem of the M-PAM receiver
function receiver_sequence = demapper(indices, M, encoding)

    % Number of bits per symbol
    bits_per_symbol = log2(M);

    % Check the encoding
    if strcmpi(encoding, "grey")

        % Convert grey to binary
        binary_indices = zeros(size(indices));
        binary_indices(:, 1) = indices(:, 1);
        for bit = 2:log2(M)
            binary_indices(:, bit) = xor(binary_indices(:, bit-1), indices(:, bit));
        end
        decimal_numbers = binary_indices;

    elseif strcmpi(encoding, "binary")

        % Perform no conversion
        decimal_numbers = indices;

    else
        error("Choose between 'grey' and 'binary' encoding.");
    end

    % Convert decimal numbers to binary sequence
    receiver_sequence = zeros(1, length(decimal_numbers) * bits_per_symbol);
    for i = 1:length(decimal_numbers)
        value = decimal_numbers(i);
        for bit = bits_per_symbol:-1:1
            receiver_sequence((i-1) * bits_per_symbol + (bits_per_symbol - bit + 1)) = bitget(value, bit);
        end
    end
end
