clc;close all;

% Low-pass filter to remove high-frequency noise to give as input to
% autoencoder network
fs = 1000;
cutoff_freq = 10;

% Normalizing the cutoff frequency
Wn = cutoff_freq / (fs / 2);

% Low-pass filter (Butterworth filter)
[b, a] = butter(2, Wn, 'low'); % 2nd order filter

% Applying the filter to the generated accelerometer data
filtered_data = filtfilt(b, a, y_out);

% Preparing the same input format for prediction
[N, n] = size(y_out);
Y_OUT = zeros([1 n 1 N]);
for i = 1:n
    for j = 1:N
        Y_OUT(1, i, 1, j) = y_out(j,i);
    end
end

% Since image input layer applies data normalization to the input, Y_OUT is
% given directly
[net,denoised] = DenoisingAutoencoder(filtered_data,Y_OUT);


denoised = squeeze(denoised);

plot(y_out, 'DisplayName', 'Original Signal'); 
xlabel('Time Samples');
ylabel('Amplitude');
hold on;
plot(denoised, 'DisplayName', 'Denoised Signal'); 
title('Denoising Autoencoder Result');
xlabel('Time Samples');
ylabel('Amplitude');
legend("original signal","denoised signal");
hold off;



%% FUNCTION SECTION

function [net,denoised] = DenoisingAutoencoder(data,signalToDenoise)
[N, n] = size(data);

%setting up input
X = zeros([1 n 1 N]);
for i = 1:n
    for j = 1:N
        X(1, i, 1, j) = data(j,i);
    end
end
 
% noisy X : 1/10th of elements are set to 0
Xnoisy = X;
mask1 = (mod(randi(10, size(X)), 7) ~= 0); 
Xnoisy = Xnoisy .* mask1;

layers = [imageInputLayer([1 n]) fullyConnectedLayer(n) regressionLayer()];

opts = trainingOptions('sgdm', ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 10, ...
    'Plots', 'training-progress');

net = trainNetwork(Xnoisy, X, layers, opts);

denoised=predict(net,signalToDenoise);
end

