% Question 2)

% Load the input signal (t)
load source.mat
t = t';

% length of the input
l = length(t);

% Initialize variables
min_value = -3.5;
max_value = 3.5;
p = [10, 1000];
N = [1, 2, 3];

% Main loop to plot the signal next to the prediction error
for i = 1:length(N)
    for j = 1:length(p)
        % Call the DPCM sender function
        [y, y_hat, a_hat, a] = dpcm_sender(t, p(j), N(i), min_value, max_value);

        % Plot the input signal next to the prediction error
        figure
        plot(t)
        hold on
        plot(y)
        hold off
        title(['Input and Prediction Error signals (p=' num2str(p(j)) ', N=' num2str(N(i)) ')']);
        xlabel('Time Index')
        ylabel('Amplitude')
        legend('Input', 'Prediction Error')
    end
end

% Question 3)

% Initialize vectors
p = 5:10;
MSE = zeros(1, length(N));

% Main loop to plot the signal next to the prediction error
for j = 1:length(p) 
    for i = 1:length(N)
        % Call the DPCM sender function
        [y, y_hat, a_hat, a] = dpcm_sender(t, p(j), N(i), min_value, max_value);
        MSE(i) = mean((t - y).^2);
    end
    figure
    plot(MSE)
    title(['Mean Squared Error (MSE) (p=' num2str(p(j)) ')']);
    xlabel('Number of Bits (N)')
    ylabel('MSE')
    disp(a);
end

% Question 4)

% Initialize vectors
p = [5, 10];

for i = 1:length(N)
    for j = 1:length(p)
        [y, y_hat, a_hat, a] = dpcm_sender(t, p(j), N(i), min_value, max_value);
        y_hat_prime = dpcm_receiver(y_hat, a_hat, p);
        figure
        subplot(1, 2, 1)
        plot(t, 'r')
        xlabel('Time')
        ylabel('Amplitude')
        title('Input Signal')
        subplot(1, 2, 2)
        plot(y_hat_prime, 'b')
        xlabel('Time')
        ylabel('Amplitude')
        title('Reconstructed Signal')
        sgtitle(['p=' num2str(p(j)) ', N=' num2str(N(i))]);
    end
end