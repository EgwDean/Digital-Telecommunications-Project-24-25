% Mapper subsystem of the M-PAM transmitter
function symbols = mapper(binary_sequence, M, encoding)

    % Check if M is a power of 2
    if mod(M, 2) ~= 0 || log2(M) ~= floor(log2(M))
        error('M must be a power of 2.');
    end

    % Number of bits per symbol
    bits_per_symbol = log2(M);

    % Compute amplitude scaling factor A (Mean Energy should be 1)
    A = sqrt(3 / (M^2 - 1));

    % Define M-PAM amplitudes based on A computed above
    amplitudes = A * (-(M-1):2:(M-1));

    % Divide the binary sequence into groups of bits of size "bits_per_symbol"
    bit_groups = reshape(binary_sequence, bits_per_symbol, [])';

    % Choose encoding
    if strcmpi(encoding, "grey")

        % Convert bit groups to decimal numbers
        decimal_numbers = bin2dec(num2str(bit_groups));
    
        % Perform Gray encoding (grey = number XOR number>>)
        indices = bitxor(decimal_numbers, floor(decimal_numbers / 2));

    elseif strcmpi(encoding, "binary")

        % Convert bit groups to decimal numbers
        indices = bin2dec(num2str(bit_groups));
    
    else
        % Error, unknown encoding
        error("Choose between 'grey' and 'binary' encoding.");
    end

    % Map the indices to the amplitudes
    symbols = amplitudes(indices + 1);

end