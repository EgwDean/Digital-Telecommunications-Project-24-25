% Uniform Quantizer
function [xq, centers] = my_quantizer(x, N, min_value, max_value)

    % Preprocess the signal to be within [min_value, max_value]
    x = max(min(x, max_value), min_value);

    % Calculate the number of quantization areas
    number_of_areas = 2^N;

    % Compute Delta (width of each area)
    Delta = (max_value - min_value) / number_of_areas;

    % Initialize arrays
    lower_bound = zeros(1, number_of_areas);
    upper_bound = zeros(1, number_of_areas);
    centers = zeros(1, number_of_areas);
    xq = zeros(1, length(x));

    % Calculate bounds and centers
    for i = 0:number_of_areas - 1
        lower_bound(number_of_areas - i) = min_value + i * Delta;
        upper_bound(number_of_areas - i) = min_value + (i + 1) * Delta;
        centers(number_of_areas - i) = min_value + (i + 0.5) * Delta;
    end

    % Quantize the signal
    for i = 1:length(x)
        for j = 1:number_of_areas
            if (x(i) >= lower_bound(j) && (x(i) < upper_bound(j) || j == 1))
                xq(i) = j;
                break;
            end
        end
    end
end
