clear all
close all
clc
%
%% --------- Inputs ----------
a = [1 2]';
b = [.5 .85]';
lmin = 1;
lmax = 2.5;
%% ------ End of Inputs -------
%
%% Matrices
c = [b' -1]';
phi = diag(b) - 2*a*b'/sum(a);
G = 2*a/sum(a);
B = diag(b);
phi_hat = [phi G;0 0 0];
B_hat = blkdiag(B,0);
G_hat = [0;0;1];
C1 = Polyhedron([-eye(3);-c';0 0 1;0 0 -1],[zeros(3,1);0;lmax;-lmin]);
C2 = Polyhedron([-eye(3);c';0 0 1;0 0 -1],[zeros(3,1);0;lmax;-lmin]);
W = Polyhedron([G_hat'*lmin; G_hat'*lmax]);
%%
%
%% Compute elements of Z_N 
m = ceil((log(lmin/(2*lmax)))/(log(max(b))));
for i = 1:m
    if i == 1
        F{1} = C2;
    else
        for j = 1:length(F{i-1})
            F{i}(j) = plus(B_hat*Polyhedron([F{i-1}(j).A;C1.A],[F{i-1}(j).b;C1.b]),W);
        end
        for j = 1:length(F{i-1})
            F{i}(j+length(F{i-1})) = plus(phi_hat*Polyhedron([F{i-1}(j).A;C2.A],[F{i-1}(j).b;C2.b]),W);
        end
    end
end
%
%
%% Construction of the convexified sequences P_j
% initialisation of the sequence
i = 1;
ZN = [];
while i <= m
    ZN = [ZN;F{i}];
    i = i + 1;
end
%
N = length(ZN);
for i = 1:N
    ZN1(i) = Polyhedron([ZN(i).A;C1.A],[ZN(i).b;C1.b]);
    ZN1(i).minHRep;
    ZN2(i) = Polyhedron([ZN(i).A;C2.A],[ZN(i).b;C2.b]);
    ZN2(i).minHRep;
end
%
vertices1 = [];
vertices2 = [];
for i = 1:N
    vertices1 = [vertices1; ZN1(i).V];
    vertices2 = [vertices2; ZN2(i).V];
end

P10 = Polyhedron(vertices1);
P10.minHRep;
P20 = Polyhedron(vertices2);
P20.minHRep;
%
iter = 15; % maximum iterations for approximating the limit set
P1(1) = P10;
P2(1) = P20;
for j = 1:iter
    P11 = plus(B_hat*P1(j), W); P11.minHRep;
    P22 = plus(phi_hat*P2(j), W); P22.minHRep;
    P11C1 = Polyhedron([P11.A;C1.A],[P11.b;C1.b]); P11C1.minHRep;
    P22C1 = Polyhedron([P22.A;C1.A],[P22.b;C1.b]); P22C1.minHRep;
    P11C2 = Polyhedron([P11.A;C2.A],[P11.b;C2.b]); P11C2.minHRep;
    P22C2 = Polyhedron([P22.A;C2.A],[P22.b;C2.b]); P22C2.minHRep;
    P1(j+1) = Polyhedron([P11C1.V;P22C1.V]); P1(j+1).minHRep;   
    P2(j+1) = Polyhedron([P11C2.V;P22C2.V]); P2(j+1).minHRep;
    clear('P11','P22')
end
%%
%
%% Plots 
figure(1);
P1(1).plot('color',[.8 .8 .8],'alpha', .20)
hold on;
P2(1).plot('color',[.4 .4 .4],'alpha',.20)
P1(end).plot('color','yellow')
P2(end).plot('color','yellow')
title('$P_{15}$','Interpreter','Latex','FontSize', 15)
xlabel('$u_1$','Interpreter','latex', 'FontSize', 18)
ylabel('$u_2$','Interpreter','latex', 'FontSize', 18)
zlabel('$\hat{\lambda}$','Interpreter','latex', 'FontSize', 18)
legend('co$(Z_N \cap C_1)$','co$(Z_N \cap C_2)$','$P_{15}$','Interpreter','latex', 'FontSize', 12)
hold off
%
% Projections
P11pro = P1(1).projection([1 2]);
P21pro = P2(1).projection([1 2]);
P1endpro = P1(end).projection([1 2]);
P2endpro = P2(end).projection([1 2]);
%
figure(2)
P11pro.plot('color',.1*[1 1 1],'alpha',.150)
hold on
P21pro.plot('color',.2*[1 1 1],'alpha',.150)
P2endpro.plot('color','yellow','alpha',.150)
hold on
P1endpro.plot('color','yellow','alpha', .750)
title('Orthogonal projection of $P_{15}$','Interpreter','Latex','FontSize', 15)
xlabel('$u_1$','Interpreter','latex', 'FontSize', 18)
ylabel('$u_2$','Interpreter','latex', 'FontSize', 18)
hold off
%
%*************************
figure(3)
P2endpro.plot('color','yellow','alpha',.150)
hold on
P1endpro.plot('color','yellow','alpha', .750)
%title('Orthogonal projection of $P_{15}$','Interpreter','Latex','FontSize', 15)
xlabel('$u_1$','Interpreter','latex', 'FontSize', 18)
ylabel('$u_2$','Interpreter','latex', 'FontSize', 18)
hold off
%*************************
% trajectories
iters = 105;
number_vertices = size([P10.V;P20.V],1);
P10P20_ver = [P10.V(:,1:2);P20.V(:,1:2)];
for i = 1:number_vertices
    uk0(:,i) = P10P20_ver(i,:)';
end
%
figure(3); hold on;
for j = 1:number_vertices
    for i = 1:iters
        if i == 1
            uk(:,i) = uk0(:,j);
        end
        mu_ = rand;
        lambda(i) = lmin*mu_ + (1-mu_)*lmax;
        if b'*uk(:,i) < lambda(i)
            uk(:,i+1) = phi*uk(:,i) + G*lambda(i);
        else
            uk(:,i+1) = diag(b)*uk(:,i);
        end
    end
    figure(3);hold on;
    plot(uk(1,1:5), uk(2,1:5),'-*','Color', .35*[1 1 1], 'LineWidth', .8)
    hold off;
    figure(4); hold on;
    plot(uk(1,:), uk(2,:),'-*','Color', .35*[1 1 1], 'LineWidth', .8)
    hold off;
end
legend('Projection of $P_1^1$','Projection of $P_1^2$',...
    'Projection of $P_{15}^1$','Projection of $P_{15}^2$','Interpreter','latex', 'FontSize', 12)
%%
