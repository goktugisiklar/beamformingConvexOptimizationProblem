clc; clear all; close all;
%%% generate noise matrix for comparisons
noise = 0.25*wgn(100,100,0);                    % w.g.noise+interference Matrix
%%% Input Parameters
N = 4:4:100;                                    % number of antenna
J = 4:4:100;                                    % number of snapshots
optimalValueMatrix_eqn4 = zeros(length(N),length(J));  % initialize optimal value matrix
snrValueMatrix_eqn4 = zeros(length(N),length(J));      % initialize snr value matrix  
optimalValueMatrix_eqn6 = zeros(length(N),length(J));  % initialize optimal value matrix
snrValueMatrix_eqn6 = zeros(length(N),length(J));      % initialize snr value matrix  
iterationNumber_eqn4 = zeros(length(N),length(J));     % initialize iteration matrix 
iterationNumber_eqn6 = zeros(length(N),length(J));     % initialize iteration matrix 
for indn = 1:length(N) 
    for indj = 1:length(J)
        n = noise(1:N(indn),1:J(indj));                     % construct noise matrix
        [optimal_eqn4, SNR_eqn4, iter_eqn4, w_eqn4] = computeOptimizationProblem(N(indn),J(indj),n,4); % compute CVX
        optimalValueMatrix_eqn4(indn,indj) = optimal_eqn4;
        snrValueMatrix_eqn4(indn,indj) = SNR_eqn4;
        iterationNumber_eqn4(indn,indj) = iter_eqn4;
        [optimal_eqn6, SNR_eqn6, iter_eqn6, w_eqn6] = computeOptimizationProblem(N(indn),J(indj),n,6); % compute CVX
        optimalValueMatrix_eqn6(indn,indj) = optimal_eqn6;
        snrValueMatrix_eqn6(indn,indj) = SNR_eqn6;
        iterationNumber_eqn6(indn,indj) = iter_eqn6;
    end
end
figure
imagesc(optimalValueMatrix_eqn4)
xlabel('N')
ylabel('J')
colorbar
figure
imagesc(optimalValueMatrix_eqn6)
xlabel('N')
ylabel('J')
colorbar
%%
% If J is fixed 
figure
plot(N,iterationNumber_eqn4,'b','linewidth',2)
hold on
plot(N,iterationNumber_eqn6,'r','linewidth',2)
grid on
xlabel('N')
ylabel('CVX iterations')
set(gca,'fontsize',12)
legend('Equation-4','Equation-6')
figure
plot(N,optimalValueMatrix_eqn4,'b','linewidth',2)
hold on
plot(N,optimalValueMatrix_eqn6,'r','linewidth',2)
grid on
xlabel('N')
ylabel('Optimal Value')
set(gca,'fontsize',12)
legend('Equation-4','Equation-6')
