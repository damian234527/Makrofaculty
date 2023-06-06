k = 2; T=2.75; Ts = 0.58; T0 = 0.35;
%k = 1.2; T = 1.5; Ts = 0.3; T0 = 0.2;
n_pos= nyquistoptions('cstprefs');
n_pos.ShowFullContour = 'off';
s = tf('s');
K0 = k / (1 + T * s) * exp(-T0 * s);
Ts = 0.3;
Kz = c2d(K0, Ts, 'ZOH')
% Part I – Description of sampled data system
    % 1. Calculate and plot step response of the system.
    figure
    step(K0)
    title('Step response of the open-loop system')
    parameters = stepinfo(K0)
    % 2. Make Nyquist and Bode plots of the system. 
    figure
    nyquist(K0, n_pos)
    title('Nyquist plot of the system')
    figure
    bode(K0)
    title('Bode plot of the system')
    % 3. Derive the discrete transfer function K(z) for given sampling time Ts (assume sampler gain  ks=1). Present zeros and poles on z-plane.
    figure
    pzmap(Kz)
    title('Zeros and poles on the z-plane')
    % 4. Calculate and plot step response of the discrete system (choose the same range of time axis as in the point 1). 
    figure
    step(Kz)
    title('Step response of the discrete time open-loop system')
    % 5. Plot frequency responses of the discrete time system: 
        % a. Nyquist 𝐾(𝑗𝜔)=𝐾(𝑧)|𝑧=𝑒𝑗𝜔𝑇𝑠  (for frequency range from 0 to Nyquist frequency N = /TS ), 
        figure
        nyquist(Kz, n_pos)
        title('Nyquist plot of the system')        
        % b. Bode - magnitude and phase (for frequencies from 0 to a specified number of repeats of N ). Find value  |K(jN )| and frequency R for which |K(j)| reaches maximum and value |K(jR)|.
        TN = pi / Ts
        figure
        bode(Kz, 0:0.01:6 * TN)
        title('Bode plot of the system')
    % 6. Perform tasks 3-5 for 
        % a) 5 times shorter and
        Ts_6a = Ts/5
        Kz_6a = c2d(K0, Ts_6a, 'ZOH');
        
        figure
        pzmap(Kz_6a)
        title('Zeros and poles on the z-plane')
        figure
        step(Kz_6a)
        title('Step response of the discrete time open-loop system')
        figure
        nyquist(Kz_6a, n_pos)
        title('Nyquist plot of the system') 
        figure
        TN_6a = pi / Ts_6a
        bode(Kz_6a, 0:0.01:6 * TN_6a)
        title('Bode plot of the system')

        % b) 3 times longer sampling period.
        Ts_6b = Ts*3
        Kz_6b = c2d(K0, Ts_6b, 'ZOH');
       
        figure
        pzmap(Kz_6b)
        title('Zeros and poles on the z-plane')
        figure
        step(Kz_6b)
        title('Step response of the discrete time open-loop system')
        figure
        nyquist(Kz_6b, n_pos)
        title('Nyquist plot of the system') 
        figure
        TN_6b = pi / Ts_6b
        bode(Kz_6b, 0:0.01:6 * TN_6b)
        title('Bode plot of the system')
        
        figure
        hold on
        pzmap(Kz, Kz_6a, Kz_6b)
        title('Comparison of Zeros and poles on the z-plane')
        legend()
        figure
        hold on
        step(Kz, Kz_6a, Kz_6b)
        title('Step response of the discrete time open-loop system')
        legend()
        figure
        hold on
        nyquist(Kz, Kz_6a, Kz_6b, n_pos)
        title('Nyquist plot of the system')
        legend()
        figure
        hold on
        bode(Kz, 0:0.01:6 * TN)
        bode(Kz_6a, 0:0.01:6 * TN_6a)
        bode(Kz_6b, 0:0.01:6 * TN_6b)
        title('Bode plot of the system')
        legend("T_s = " + Ts, "T_s = " + Ts_6a, "T_s = " + Ts_6b)
    % 7. Discuss influence of sampling period on zeros and poles of a discrete transfer function and time and frequency responses. Compare results to the continuous time system responses. Formulate conclusions.

% Part II – Closed loop sampled data system 
% For the controller Kr(z) = kr and  plant transfer function obtained in part I (for given TS): 
    % 1. Determine analytically the range of the gain kr for which closed loop system is stable.
    
    % 2. Plot root locus of the system. Check value of critical gain.  
    figure
    rlocus(Kz)
    % 3. Using root locus plot select from the range of stability values of the gain kr for which roots of the characteristic equation are: 
    % a. real, b. complex. 
    figure
    rlocus(Kz)
    ylim([-1 1])
    % 4. Print step responses of the system for selected gains and determine steady state output yss and steady state error ess . Discuss differences. 
    kc1 = 0.5;
    kc2 = 2;
    K1 = Kz * kc1;
    K2 = Kz * kc2;
    Kcl_Y1 = K1 / (1 + K1);
    Kcl_Y2 = K2 / (1 + K2);

    [Y1, Z1] = step(Kcl_Y1);
    [Y2, Z2] = step(Kcl_Y2);
    figure
    stem(Z1, Y1, 'blue')
    hold on;
    stem(Z2, Y2, 'red')
    legend("kc = " + kc1, "kc = " + kc2)
    title('Step responses y(nTs) of the discrete-time systems')

    Kcl_E1 = 1 / (1 + K1);
    Kcl_E2 = 1 / (1 + K2);

    [E1, Z1] = step(Kcl_E1);
    [E2, Z2] = step(Kcl_E2);
    figure
    stem(Z1, E1, 'blue')
    hold on;
    stem(Z2, E2, 'red')
    legend("kc = " + kc1, "kc = " + kc2)
    title('Step responses e(nTs) of the discrete-time systems')
    % 5. Find analytical form of E(z) and e(nTs). Calculate ess and yss. Compare results to computer simulation. 
    
    % 6. Discuss obtained results.  
    
    % 7. Compare sampled data and continuous-time systems. 
