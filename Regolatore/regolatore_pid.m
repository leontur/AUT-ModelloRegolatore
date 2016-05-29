close all
clear all
clc

% laboratorio precedente
%     mu=3.7/30;
%     Tau11=100;
%     M1=tf(mu,[Tau11 1]);
%     Tau21 = Tau11/10;
%     M2=tf(mu,conv([Tau11 1],[Tau21 1]));
%     Tau1 = 120;
%     Tau2 = Tau1/10;
%     Tau3 = Tau1/10;
%     T1 = Tau1/3;
%     M3=tf(mu*[T1 1],conv(conv([Tau1 1],[Tau2 1]),[Tau3 1]));
%     M4=tf(mu*[48 1],conv(conv([78 1],[20 1]),[12 1]));

M1=tf(0.067,[70 1]);
M2=tf(0.067,conv([65 1],[8 1]));
M3=tf(0.067*[12 1],conv(conv([60 1],[15 1]),[7 1]));
M4=tf(0.067*[48 1],conv(conv([78 1],[20 1]),[12 1]));

% sintesi del regolatore R1
    Ti=70;
    K=5/120*Ti/0.067;
    R1=K*(1+tf(1,[Ti 0]));
    step(R1*M1/(1+R1*M1),150);
    [gm,pm,wu,wc]=margin(R1*M1); [gm,pm,wu,wc]
    [gm,pm,wu,wc]=margin(R1*M2); [gm,pm,wu,wc]
    [gm,pm,wu,wc]=margin(R1*M3); [gm,pm,wu,wc]
    [gm,pm,wu,wc]=margin(R1*M4); [gm,pm,wu,wc]
    figure
    subplot(211);
    step(R1*M1/(1+R1*M1),R1*M2/(1+R1*M2),R1*M3/(1+R1*M3),R1*M4/(1+R1*M4),150);
    grid
    subplot(212);
    step(R1/(1+R1*M1),R1/(1+R1*M2),R1/(1+R1*M3),R1/(1+R1*M4),150);
    grid
    figure
    bode(M1, 'b',M2, 'xb',M3, 'r',M4, 'g');
    grid on;

% secondo regolatore
    K=0.005*Ti/0.067;
    R2=K*(1+tf(1,[Ti 0]));
    figure
    subplot(211);
    step(R2*M1/(1+R2*M1),R2*M2/(1+R2*M2),R2*M3/(1+R2*M3),R2*M4/(1+R2*M4),3000);
    grid
    subplot(212);
    step(R2/(1+R2*M1),R2/(1+R2*M2),R2/(1+R2*M3),R2/(1+R2*M4),3000);
    grid

% terzo regolatore
    K=0.5*Ti/0.067;
    R3=K*(1+tf(1,[Ti 0]));
    figure
    subplot(211);
    step(R3*M1/(1+R3*M1),R3*M2/(1+R3*M2),R3*M3/(1+R3*M3),R3*M4/(1+R3*M4),100);
    grid
    subplot(212);
    step(R3/(1+R3*M1),R3/(1+R3*M2),R3/(1+R3*M3),R3/(1+R3*M4),100);
    grid
    
% prestazioni anello chiuso con regolatore PID
    Wc = 0.05;
    T = 2;
    figure
    bode(tf(1,conv([1/Wc 0],[T 1])));

% quarto regolatore
    R4=1/M2*tf(1,conv([1/Wc 0],[T 1]));
    figure
    margin(R4*M2);

% determinazione dei coefficienti PID in forma ISA per la taratura del
% controllore

    n = R4.num{1};
    d = R4.den{1};

    % Td/N = d(1)/d(2);
    % K/Ti = 1/d(2);
       
    Ti = n(2)-d(1)/d(2)
    % Ti*Td*(1+1/N) = n(1);  % Ti*(Td+Td/N) = n(1);
    % Td = n(1)/Ti - Td/N;
    Td = n(1)/Ti - d(1)/d(2)
    N = Td*d(2)/d(1)
    K = Ti/d(2)
    
% verifica correttezza parametri PID
    figure
    bode(R4, '+',K*(1+tf(1,[Ti 0])+tf([Td 0],[Td/N 1])));




















