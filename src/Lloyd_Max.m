% Non Uniform Quantizer Using Lloyd-Max Algorihtm
function [xq, centers, D, lower_bound, upper_bound] = Lloyd_Max(x, N, min_value, max_value)

    % Tolerance for convergence
    tol = 1e-36;

    % Preprocess the signal to be within [min_value, max_value]
    x = max(min(x, max_value), min_value);

    % Calculate number of quantization areas
    number_of_areas = 2^N;

    % Compute Delta (width of each area)
    Delta = (max_value - min_value) / number_of_areas;

    % Initialize centers
    centers = zeros(1, number_of_areas);
    for i = 0:number_of_areas - 1
        centers(number_of_areas - i) = min_value + (i + 0.5) * Delta;
    end

    % Include extreme values to the centers temporarily
    centers = [min_value, centers, max_value];

    % Initialize vectors
    D = [];
    xq = zeros(1, length(x));
    lower_bound = zeros(1, number_of_areas);
    upper_bound = zeros(1, number_of_areas);

    iteration = 1;

    while true
        % Step 1: Calculate quantization bounds
        lower_bound(1) = centers(1);
        upper_bound(1) = (centers(2) + centers(3)) / 2;
        for i = 2:number_of_areas - 1
            lower_bound(i) = (centers(i) + centers(i+1)) / 2;
            upper_bound(i) = (centers(i+1) + centers(i+2)) / 2;
        end
        lower_bound(end) = (centers(end - 2) + centers(end - 1)) / 2;
        upper_bound(end) = centers(end);

        % Step 2: Quantize the signal
        for i = 1:length(x)
            [~, xq(i)] = min(abs(x(i) - centers(2:end - 1)));
        end

        % Step 3: Compute mean distortion
        quantized_values = centers(xq + 1);
        distortion = mean((x - quantized_values).^2);
        D = [D, distortion];

        % Step 4: Update centers
        for k = 1:number_of_areas
            points_in_area = x(x >= lower_bound(k) & x < upper_bound(k));
            if ~isempty(points_in_area)
                centers(k + 1) = mean(points_in_area);
            end
        end

        % Stop if the change in distortion is less than the tolerance
        if (iteration > 1 && abs(D(iteration) - D(iteration-1)) < tol)
            break;
        end

        % Increment iteration
        iteration = iteration + 1;
    end

    % Remove bounds from centers for final output
    centers = centers(2:end-1);

end


