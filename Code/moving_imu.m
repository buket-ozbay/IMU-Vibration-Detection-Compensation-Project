clc;clear;close all;
%% Simulation of moving object with imuSensor and waypointTrajectory to understand the behavior of IMU

waypoints = [0, 0, 0; 10, 10, 0; 20, 5, 0]; % X, Y, Z coordinates
waypointTimes = [0, 5, 10]; % The arrival time to each waypoint (s)

% Trajectory assignment
traj = waypointTrajectory('Waypoints', waypoints, ...
    'TimeOfArrival', waypointTimes, ...
    'SampleRate', 100);

% imuSensor assignment
imu = imuSensor('accel-gyro', ...
    'SampleRate', 100, ...
    'ReferenceFrame', 'ENU'); %ENU (East:x-North:y-Up:z)

% To simulate moving object these are the data
accData = zeros(3, 3); % acceleration data (X, Y, Z)
gyroData = zeros(3, 3); % gyro data (X, Y, Z)
count = 1;

% Collecting data for each waypoint as you proceed along the orbit
while ~isDone(traj)
    % Gets current position and acceleration, angular velocity data from trajectory
    [pos, ~, acc, angVel] = traj();
    
    % Simulation of data with IMU sensor
    [accData(count, :), gyroData(count, :)] = imu(acc, angVel);
    
    % Visualization of positions
    plot(pos(1), pos(2), 'bo');
    xlabel("X");
    ylabel("Y");
    hold on;
    
    count = count + 1;
end

hold off;

numSamples = size(accData, 1);
time = (0:numSamples-1)' / imu.SampleRate; % Calculates the correct time for each sample

%% PLOTTING
figure;
subplot(2, 1, 1);
plot(time, accData);
title('Accelerometer Data (Moving Device)');
xlabel('Time (s)');
ylabel('Acceleromation (m/s^2)');
legend('X', 'Y', 'Z');

subplot(2, 1, 2);
plot(time, gyroData);
title('Gyroscope Data (Moving Device)');
xlabel('Time  (s)');
ylabel('Angular Velocity (rad/s)');
legend('X', 'Y', 'Z');
