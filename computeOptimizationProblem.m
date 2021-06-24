%%% This function creates the beamforming optimization parameters for given
%%% number of antenna array elements (N), number of time-snapshots (J),
%%% preconstructed noise matrix (n), and optimization problem definition,
%%% i.e., 4 or 6
function [optimalValue, snrValue, iterNumber, weightingCoef] = computeOptimizationProblem(N,J,n,eqn)
%%% Input Parameters
frequency = 1e9;                        % frequency of the signal: 1 GHz
lambda = 3e8/frequency;                 % wavelength of the signal
omega = 2*pi*frequency;                 % angular frequency
k = 2*pi/lambda;                        % wavevector
time_step = 25e-6;                      % time-step between each snapshot
t = linspace(0,J*time_step,J);          % time vector with J samples
d = 0.28*lambda;                        % distance between array elements
d_array = 0:d:(N-1)*d;                  % antenna array distance vector
a_s = exp(-1i*k*d_array);               % estimated steering vector as a function of antenna position
a_s = transpose(a_s);                   % column vector arrangement
eps_upperbound = 1e-3;                  % upper-bound error value for steering vector approx.
%%% Computing the Received Signal
s_bold = zeros(N,J);                    % desired signal
for indn = 1:N
    for indt = 1:length(t)
        s_bold(indn,indt) = 2.5*sin(omega*t(indt))*a_s(indn,1);      % desired waveform * estimated steering vector
    end
end
Y = n + s_bold;                         % received signal matrix
R_hat = (1/J)*(Y*Y');                   % matrix for computing SNRs
%%% CVX Optimization Solver
cvx_begin
    variable w(N) complex;              % antenna array coefficients
    % minimizing the noise
    minimize(w'*R_hat*w)
    subject to
    if eqn == 4
        w'*a_s == 1;
    else
        % w'a_s has to be real and positive for the worst-case scenario
        imag(w'*a_s) == 0;
        real(w'*a_s) >= eps_upperbound*norm(w) + 1;
    end 
cvx_end
%%% Compute Outputs
optimalValue = cvx_optval;
iterNumber = cvx_slvitr;
weightingCoef = w;
P = 0.5;
snrValue = (P^2)*abs(w'*a_s)/(w'*R_hat*w);
snrValue = 10*log10(abs(snrValue));
end