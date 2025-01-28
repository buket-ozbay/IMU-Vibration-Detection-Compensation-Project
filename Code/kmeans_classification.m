%-----------------------------------------------------------------------
% 1) Data and basic parameters
%-----------------------------------------------------------------------

acc = y_out;                           % Generated y_axis data
L = 50;                                % Length of each window
Nwin = size(acc,1) / L;                % Total number of windows = 3060
Fs = 50;                               % Sampling frequency
freq_single = (0 : L/2) * (Fs / L);    % Frequency axis 


%-----------------------------------------------------------------------
% 2) Taking the FFT for each window and calculating the RMS value
%-----------------------------------------------------------------------

rms_spectrum = zeros(L/2 + 1, 1);      % Initialize rms_spectrum 

for ch = 1:1 

    % Reshape the data of size (L x Nwin) = [50 x 3060]
    data_ch = reshape(acc(:, ch), L, Nwin);  
   
    % Calculate FFT of each window
    fft_data = fft(data_ch, L, 1); 

    % Calculate power spectrum= |FFT|^2
    power_spectrum = abs(fft_data).^2; 

    % Take the first (L/2+1) section for (single-sided) 
    % Including DC (0 Hz) and Nyquist (Fs/2) components
    power_spectrum_single = power_spectrum(1 : L/2+1, :); 

    % Average the powers in each frequency bin across windows:
    mean_power = mean(power_spectrum_single, 2);  % boyut: [26 x 1]
 
    % compute RMS 
    rms_spectrum = sqrt(mean_power);
    
end

%-----------------------------------------------------------------------
% 3) Plotting results
%-----------------------------------------------------------------------
figure('Name','RMS Spectrum','Color','w');
plot(freq_single, rms_spectrum(:,1),'b','LineWidth',1.5);
xlabel('Frequency [Hz]'); ylabel('RMS Amplitude');
grid on;


%% K-MEANS PART


features =  rms_spectrum;

% k-means clustering
num_clusters = 2;
[idx, centroids] = kmeans(features, num_clusters);

% Visualize k-means clustering
figure;
scatter(1:length(features), features, 50, idx, 'filled');
xlabel('Index');
ylabel('RMS Spectrum Value');
title('Clustering Results With K-Means');
colorbar;


%  Average RMS and FFT values for each cluster
mean_features = zeros(num_clusters, size(features, 2));
for k = 1:num_clusters
    mean_features(k, :) = mean(features(idx == k, :), 1);
end

% Visualize the silhouette plots
silhouette(features, idx);
title('Silhouette Analysis for K-means Clustering');

% Extract silhouette values
[silValues, ~] = silhouette(features, idx);

% Compute the mean silhouette value
avgSilhouette = mean(silValues); 
disp(['Average Silhouette Value: ', num2str(avgSilhouette)]);



