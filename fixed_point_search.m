clear all
clc
close all
%
alfa = [1 2]'; % 1*[1/4 2/4]';% 10*rand(1000,1);% [1 2 3 4]';
beta = [0.85 0.15]';% ones(3,1)*.55; %[.9 .9]';% rand(1000,1);%[.8 .75 .6 .55]';
umax = 100*[7 5]';  %randi(10,1000,1);% 1*[2 6 3 4]';
lambda = 3; %.75*sum(umax);
%
if sum(umax) <= lambda
    fprintf('Lambda is greater than the total capacity!!!\n')
    return;
end
%
n = length(alfa);
fp = zeros(n,1);
index_unsat = []; % set of indices (unsaturated nodes)
index_sat = [];   % set of indices (saturated nodes)
T_under = 0;
T_over = 0;
T_mixed = 0;
Tstar = 0;
ustar = zeros(n,1);
%
% find the fixed point
T_under = 2*lambda / sum(alfa.*((1+beta)./(1-beta)));
u_unsat = (alfa./(1-beta))*T_under;
count_unsat = 0;
count_sat = 0;
for i = 1:n
    if u_unsat(i) < umax(i)
        count_unsat = count_unsat + 1;
        index_unsat(count_unsat) = i;
    else
        count_sat = count_sat + 1;
        index_sat(count_sat) = i;
    end
end
if isempty(index_sat)
    Tstar = T_under
    ustar = u_unsat
    fprintf('No saturating fixed point is found\n')
    return;
end
if isempty(index_unsat)
    Tstar = .5*sum((1-beta).^2.*umax.^2./alfa)/(sum(umax) - lambda)
    ustar = umax
    fprintf('A fully saturating fixed point is found\n')
    return;
end
flag = 1;
iterations = 0;
%
while flag
    iterations = iterations + 1;
    check1 = 0;
    remove_index_unsat = [];
    %
    [a_sat, b_sat, um_sat] = find_sat_par(alfa, beta, umax, index_sat);
    [a_unsat, b_unsat, um_unsat] = find_unsat_par(alfa, beta, umax, index_unsat);
    %
    A1 = .5*sum(a_unsat.*((1+b_unsat)./(1-b_unsat)));
    A2 = sum(um_sat) - lambda;
    A3 = -.5*sum((1-b_sat).^2.*um_sat.^2./a_sat);
    %
    T_mixed = max(roots([A1 A2 A3]));
    lambda_over = lambda - A1*T_mixed;
    lambda_under = lambda - lambda_over;
    T_under = lambda_under / A1;
    u_unsat = (a_unsat./(1-b_unsat))*T_under;
    n = length(u_unsat);
    for i = 1:n
        if u_unsat(i) >= umax(index_unsat(i))
            index_sat = [index_unsat(i) index_sat];
            remove_index_unsat = [index_unsat(i) remove_index_unsat];   % [] (index_unsat == index_unsat(i)) = [];
            check1 = check1 + 1;
        end
    end
    for i = 1:length(remove_index_unsat)
        index_unsat(index_unsat == remove_index_unsat(i)) = [];
    end
    if check1 == 0 || isempty(index_unsat)
        flag = 0;
    end
end
%
index_sat = sort(index_sat);
index_unsat = sort(index_unsat);
Tstar = T_mixed
ustar = min((alfa./(1-beta))*T_mixed, umax)
fprintf('Nodes ')
for i = 1:length(index_sat)
    fprintf('%.d ', index_sat(i))
end
fprintf('saturate\n')
%
if ~isempty(index_unsat)
    fprintf('Nodes ')
    for i = 1:length(index_unsat)
        fprintf('%.d ', index_unsat(i))
    end
    fprintf('do not saturate\n')
end
iterations
%
%
function [a_sat, b_sat, um_sat] = find_sat_par(alfa, beta, umax, index_sat)
count = 0;
for i = 1:length(index_sat)
    count = count + 1;
    a_sat(count) = alfa(index_sat(count));
    b_sat(count) = beta(index_sat(count));
    um_sat(count) = umax(index_sat(count));
end
end
%
function [a_unsat, b_unsat, um_unsat] = find_unsat_par(alfa, beta, umax, index_unsat)
count = 0;
for i = 1:length(index_unsat)
    count = count + 1;
    a_unsat(count) = alfa(index_unsat(count));
    b_unsat(count) = beta(index_unsat(count));
    um_unsat(count) = umax(index_unsat(count));
end
end    









