syms s
w1 = 1/s
w2 = 1/s^2
K0_num = 2.5;
K0_den = s*(1+3*s);
K0s = K0_num/K0_den
clear s
s = tf('s');
%K0= k/(s*(1+sT))
%k = 2.5 T = 3
K0 = tf(K0_num,sym2poly(K0_den))
kr=1;
K=K0*kr;

% 1. Assuming  𝑧(𝑡) = 0,𝐾𝑟(𝑠) = 𝑘𝑟 ,𝐾0(𝑠) = 𝑘/(𝑠(1+𝑠𝑇))
    % a) check stability using Hurwitz criterion. 
    
    % b) find the error transfer function 𝐾𝑒(𝑠) = 𝐸(𝑠) 𝑊(𝑠) : . 
    [W_num, W_den] = numden(w1)
    W = tf(sym2poly(W_num), sym2poly(W_den))
    E=W*1/(1+K);
    Y=W*K/(1+K);
    % c) assuming w(t) = 1(t) find analytical form of e(t); determine steady state error. 
    
    % d) plot time responses e(t) and y(t).
    
    %e = ilaplace(E)
    %y = ilaplace(Y)
    impulse(E)
    title("Time response e(t)")
    figure
    impulse(Y)
    title("Time response y(t)")
    % e) compare analytical results to computer simulation. 

    % f) calculate steady state error for w(t) = t 1(t).
    clear s
    syms s
    Ks=K0s*kr;
    ess = limit(s*w1*1/(1+Ks),s,0)
    yss = limit(s*w1*Ks/(1+Ks),s,0)
    
    % g) determine the type of the system with respect to w(t).
    
% 2. Assuming Kr(s) and Ko(s) as defined in step 1 and w(t) = 0; 
    % a) find disturbance transfer function 𝐾𝑧(𝑠) = 𝐸(𝑠) 𝑍(𝑠) 
    
    Kz= K0/(1+K)
    % b) calculate steady state error assuming: - z(t) = 1(t)  - z(t) = t 1(t); 
    syms s
    ess2 = limit(s*w1*K0s/(1+Ks),s,0)
    ess3 = limit(s*w2*K0s/(1+Ks),s,0,"right")
    % c) plot time response e(t), compare results. 
    Z1=W
    E1=Z1*Kz;

    [Z2_num, Z2_den] = numden(w2)
    Z2 = tf(sym2poly(Z2_num), sym2poly(Z2_den))
    E2=Z2*Kz;
    figure
    impulse(E1)
    title("Time response e(t) for z(t) = 1(t)")
    figure
    impulse(E2)
    xlim([0 40])
    title("Time response e(t) for z(t) = t 1(t)")
    % d) determine the type of the system with respect to z(t). 

% 3. For controllers:  
    % a) 𝐾𝑟(𝑠) = 𝑘𝑟/𝑠 

    % b) 𝐾𝑟(𝑠) = 𝑘𝑟(1+𝑠𝑇𝑑) 

    % c) 𝐾𝑟(𝑠) = 𝑘𝑟(1+ 1/(𝑠𝑇𝑖) ) using Hurwitz criterion determine the range of controllers parameters ( 𝑘𝑟,𝑇𝑑 and 𝑇𝑖) for which the system is stable.

% 4. Using results from step 3 choose parameters for each controller. For obtained three control systems plot error signal e(t): 
%     clear s
%     syms s kr td ti
%     eqns1 = [det([1, 2.5*kr; 3, 0]) == 0, det([1, 2.5*kr, 0; 3, 0, 0; 0, 1, 2.5*kr]) == 0]
%     eqns2 = [1+2.5*kr*td == 0, det([1+2.5*kr*td, 0; 3, 2.5*kr]) == 0]
%     eqns3 = [det([1, (2.5*kr)/ti; 3, 2.5*kr]) == 0, det([1, (2.5*kr)/ti, 0; 3, 2.5*kr, 0; 0, 1, (2.5*kr)/ti]) == 0]
%     S1 = solve(eqns1,kr)
%     S2 = solve(eqns2,kr,td, ReturnConditions=true)
%     S3 = solve(eqns3,kr,ti, ReturnConditions=true)
    
    limit(s*1/s^3*1/(1+K0s*6/s),s,0)
    limit(s*1/s^3*1/(1+K0s*0.5 *(1 + s * 1)),s,0,"right")
    limit(s*1/s^3*1/(1+K0s*2*(1 + 1 / (s * 5))),s,0)

    limit(s*1/s^2*K0s/(1+K0s*6/s),s,0)
    limit(s*1/s^2*K0s/(1+K0s*0.5 *(1 + s * 1)),s,0,"right")
    limit(s*1/s^2*K0s/(1+K0s*2*(1 + 1 / (s * 5))),s,0)
    return
    clear s
    s = tf('s')
    krI = 6;
    krPD = 0.5;
    Td = 1;
    krPI = 2;
    Ti = 5;

    W = 1 / s;
    Z = 1 / s;

    KrI = krI/s;
    KI = K0*KrI;

    KrPD = krPD *(1 + s * Td);
    KPD = K0 * KrPD;

    KrPI = krPI *(1 + 1 / (s * Ti));
    KPI = K0 * KrPI;

    % a) assuming w(t) = 1(t) and z(t) = 0.
    
    
    EI_W = W*1/(1+KI);
    EPD_W = W * 1 / (1 + KPD);
    EPI_W = W * 1 / (1 + KPI);

    % b) assuming z(t) = 1(t) and w(t) = 0. 
    EI_Z = Z*K0/(1+KI);
    EPD_Z = Z * K0 / (1 + KPD);
    EPI_Z = Z * K0 / (1 + KPI);

    figure
    subplot(2,1,1)
    impulse(EI_W)
    title("Integral controller: e(t) for w(t) = 1(t)")
    subplot(2,1,2)
    impulse(EI_Z)
    title("Integral controller: e(t) for z(t) = 1(t)")

    figure
    subplot(2,1,1)
    impulse(EPD_W)
    title("PD controller: e(t) for w(t) = 1(t)")
    subplot(2,1,2)
    impulse(EPD_Z)
    title("PD controller: e(t) for z(t) = 1(t)")

    figure
    subplot(2,1,1)
    impulse(EPI_W)
    title("PI controller: e(t) for w(t) = 1(t)")
    subplot(2,1,2)
    impulse(EPI_Z)
    title("PI controller: e(t) for z(t) = 1(t)")

% 5. In each case determine the type of the system with respect to w(t) and z(t). 

% 6. Discuss obtained results. 
