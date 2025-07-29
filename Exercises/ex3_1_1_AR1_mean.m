%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This exercise compares two AR(1) processes with and without the intercept
% term.

% (1) y_{t} = 0.5*y_{t-1} + e_{t}, e_{t}~WN(0,0.25)
% (2) y_{t} = 1 + 0.5*y_{t-1} + e_{t}, e_{t}~WN(0,0.25)

% The mean of equation (2) is mu = c/(1-alpha) = 1/(1-0.5) = 2.

% Written by Hyun Jae Stephen Chu
% July 28th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Settings
clear; clc;
close all
rng(123)

addpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/Exercises")
addpath(genpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/TS_lib"))

file_dir = '/Users/hjchu/Documents/GitHub/Time_Series_Package/Exercises/ex3_2_results';

%% DGP
% True parameters
c = 1;
alpha = 0.5;
sigma = 0.25;
% mu = c / 1-alpha = 2

burn_in = 50;
burn_out = 200;
T = burn_in + burn_out;

% (1) Generating AR(1) process with mean zero
Y1 = zeros(T+1,1);

for t = 1:T
    Y1(t+1,1) = alpha*Y1(t,1) + sqrt(sigma)*randn(1);
end

Y1 = Y1(burn_in+2:end);

% (2) Generating AR(1) process with mean mu = c/(1-alpha)
Y2 = zeros(T+1,1);

for t = 1:T
    Y2(t+1,1) = c + alpha*Y2(t,1) + sqrt(sigma)*randn(1);
end

Y2 = Y2(burn_in+2:end);

%% Plotting
f1 = figure(1);
plot((1:burn_out)',Y1, '-k', 'linewidth', 1.5)
% title("AR(1) process with $c=0$", 'fontsize', 16, 'interpreter', 'latex')
max1 = max(Y1);
min1 = min(Y1);
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 burn_out q*min1 1.1*max1])
yline(0,'-b','LineWidth',1.5)
yline(mean(Y1),'-r','LineWidth',1.5)
xlabel("Time", 'interpreter', 'latex')
ylabel("Y", 'interpreter', 'latex')
xticks([1,50,100,150,200])
legend({'$y_{t}$','$c/(1-\alpha)$','$mean(y_{t})$'},'Interpreter','latex')
grid on

saveas(f1, fullfile(file_dir, 'figure1.png'))

f2 = figure(2);
plot((1:burn_out)',Y2, '-k', 'linewidth', 1.5)
% title("AR(1) process with $c=1$", 'fontsize', 16, 'interpreter', 'latex')
max2 = max(Y2);
min2 = min(Y2);
if min2 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 burn_out q*min2 1.1*max2])
yline((c/(1-alpha)),'-b','LineWidth',1.5)
yline(mean(Y2),'-r','LineWidth',1.5)
xlabel("Time", 'interpreter', 'latex')
ylabel("Y", 'interpreter', 'latex')
xticks([1,50,100,150,200])
legend({'$y_{t}$','$c/(1-\alpha)$','$mean(y_{t})$'},'Interpreter','latex')
grid on

saveas(f2, fullfile(file_dir, 'figure2.png'))