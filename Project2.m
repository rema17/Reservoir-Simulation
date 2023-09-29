clc
clear all
close all 


% Simulation parameters
dx = 1000;
dy = 1000;
h = 75;
Kx = 0.015;
U = 10;
Vb = h * dx * dy;
Q = 0.18;
ct = 3.5e-6;
B = 1;
Bc = 1.127;
Vcon = 5.615;
q = 150;
n = 10;
Ax = h * dy;
Tx = (Bc * Ax * Kx) / (U * B * dx);
v = (Vcon * B * U) / (Vb * Q * ct);
time = 360; % days

% Time steps
dt_values = [3];

% Initialize pressure matrix
nt = 360 / min(dt_values);
P = zeros(nt + 1, n);
P(1, :) = 6000;

% Run simulation for each time step
for dt = dt_values
    nt = time / dt;
    for i = 1:nt
        P(i+1, 1) = P(i, 1) + v*((Tx*P(i, 2)) - (2*Tx*P(i, 1)) + (Tx*P(i, 1)));
        for j = 2:3
            P(i+1, j) = P(i, j) + v*((Tx*P(i, j+1)) - (2*Tx*P(i, j)) + (Tx*P(i, j-1)));
        end
        P(i+1, 4) = P(i, 4) + (-v*q) + v*((Tx*P(i, 5)) - (2*Tx*P(i, 4)) + (Tx*P(i, 3)));
        for j = 5:8
            P(i+1, j) = P(i, j) + v*((Tx*P(i, j+1)) - (2*Tx*P(i, j)) + (Tx*P(i, j-1)));
        end
        P(i+1, 9) = P(i, 9) + v*((Tx*P(i, 9)) - (2*Tx*P(i, 9)) + (Tx*P(i, 8)));
    end
end

% Plot pressure distribution 2D
fig = figure();
t = 0:3:time;
% plot pressure over time for each grid block
for i = 1:n
    plot(t, P(:, i), 'DisplayName', sprintf('Grid Block %d', i));
    hold on;
end
hold off;
% set axis labels and title
xlabel('Time');
ylabel('Pressure');
title('Pressure Distribution in Reservoir');
% add legend and show plot
legend('Location', 'best');
grid on;

