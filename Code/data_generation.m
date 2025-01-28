clc; close all;
%% Simulation parameters
T = 15.3 * 1e4;                 % Total duration (seconds)
t = (1:1:T).';                  % Time vector (column)

% Define vibration bursts (adjusted intervals with vibrations)
burst1 = (t >= 4 * 1e4  & t < 6 * 1e4 );
burst2 = (t >= 10 * 1e4  & t < 12 * 1e4 );

% Scale vibration intensity to increase then decrease (like a bell curve)
vibrationEnvelope1 = burst1 .* (1 - cos(pi * (t - 4 * 1e4 ) / (2 * 1e4 ))); % Adjusted for 4-6x1e4 seconds
vibrationEnvelope2 = burst2 .* (1 - cos(pi * (t - 10 * 1e4 ) / (2 * 1e4 ))); % Adjusted for 10-12x1e4 seconds

% Combine envelopes for total vibration intensity over time
vibrationMask = vibrationEnvelope1 + vibrationEnvelope2;

%% Baseline (quiet) noise
% Small random noise to simulate sensor noise outside of vibration bursts
rng('default');   % For reproducibility
x_baseline = 0.1 * randn(size(t)) + 1.004; 
y_baseline = 0.1 * randn(size(t)) + 0.009;
z_baseline = 0.1 * randn(size(t)) - 0.125;

%% Vibration signal
% Use the vibrationMask to vary intensity over time
x_vib = vibrationMask .* (2 * randn(size(t)) + 2 * sin(2 * pi * 1 * t));
y_vib = vibrationMask .* (1.5 * randn(size(t)) + 1 * sin(2 * pi * 15 * t));
z_vib = vibrationMask .* (randn(size(t)) + 1.5 * sin(2 * pi * 12 * t));


%% Combine baseline and vibration
x_out = x_baseline + x_vib;
y_out = y_baseline + y_vib;
z_out = z_baseline + z_vib;

generated_data = [x_out y_out z_out];

%% Plot results
figure('Color','w','Position',[100 100 900 500])
plot(t, x_out, 'r'); hold on;
plot(t, y_out, 'g');
plot(t, z_out, 'b');
legend('X-axis','Y-axis','Z-axis','Location','Best');
xlabel('Time (s)');
ylabel('Acceleration (g)');
title('Synthesized 3-Axis Acceleration Data with Extended Time');
grid on;
xlim([0 T]);