k = 2.5; T1 = 2; T2 = 1; T3 = 3.5
%k = 1.5; T1 = 2; T2 = 4; T3 = 1.5
%k = 2; T1 = 1; T2 = 1.5; T3 = 0.5
n_pos= nyquistoptions('cstprefs');
n_pos.ShowFullContour = 'off'; 
syms s
K0_num = k;
K0_den = (1+s*T1)*(1+s*T2)*(1+s*T3);
K0s = K0_num/K0_den;
clear s
s = tf('s');
K0 = k/((1+s*T1)*(1+s*T2)*(1+s*T3));

% A. Uncompensated CL system analysis (Kc(s) = 1): 
%     1. Using Nyquist or root locus plot estimate a critical gain kcrit.
critical_gain(K0)
%     2. Find the gain k for which the gain margin of the system Δ𝐴 = 2 (or the phase margin Δφ = π/6)
k_val = gain_for_A2(K0, T1, T2, T3, 0, 0)
%     3. Print the Nyquist plot for obtained gain k.
K_gain = nyquist_gain(K0,k_val);
title("Nyquist plot for uncompensated system")
%     4. Plot the closed-loop system step response.
kcl = closed_step(K_gain)
title("Step response for uncompensated system")
%     5. Plot the tracking index 𝑀(𝜔) = | 𝐾(𝑗𝜔) / 1+𝐾(𝑗𝜔) | and attenuation index 𝑞(𝜔) = | 1
track_att(K_gain)
% B. Phase-lag (PI) compensation (𝐾𝑐(𝑠) = 1+𝑠𝑇 1+𝑠𝛼𝑇 1+𝐾(𝑗𝜔) | ). ): 
%     1. Assume 𝛼 = 4 and find the time constant T of the compensator, following the designing procedure. 
 alpha = 4;
 syms s w_x T
 d = pi/36;
 w_x = vpa(solve([-atan(T1*w_x)-atan(T2*w_x)-atan(T3*w_x)==-pi+d,w_x > 0],w_x))
 T = vpa(solve(atan(T*w_x)-atan(alpha*T*w_x)==-d))
 T = real(double(T))
 clear s
 s = tf("s");
 
 PI = (1 + s * T(1)) / (1 + s * alpha * T(1))
 subplot(2,1,1)
 nyquist(PI,n_pos)
 title("Nyquist plot T = " + T(1))
 PI = (1 + s * T(2)) / (1 + s * alpha * T(2));
 subplot(2,1,2)
 nyquist(PI,n_pos)
 title("Nyquist plot T = " + T(2))
 KPI = PI*K0;
 figure
 nyquist(KPI,n_pos)
 title("Nyquist plot for system with PI compensator and gain k = 1")

 T = max(T)
%     2. Find a critical gain 𝑘𝑐𝑟𝑖𝑡  for the compensated system.
 k_PI = critical_gain(KPI);
%     3. Calculate the gain k so that for the compensated system: Δ𝐴 = 2 (𝑜𝑟 Δ𝜑 = 𝜋 6 Nyquist plot. ) and print the Nyquist plot
k_PI_val = gain_for_A2(KPI, T1, T2, T3, T, alpha*T)
k_PI_val
 K_PI_gain = nyquist_gain(KPI,k_PI_val);
 title("Nyquist plot for system with PI compensator")
%     4. Plot the CL system step response.
 kcl_PI = closed_step(K_PI_gain)
 title("Step response for system with PI compensator")
%     5. Plot the tracking index 𝑀(𝜔) and the attenuation index 𝑞(𝜔). 
 track_att(K_PI_gain)
%     6. Compare the characteristics for the uncompensated and PI-compensated systems. Discuss the properties of the phase-lag compensation. 

figure
nyquist(K_gain,n_pos)
hold on
nyquist(K_PI_gain,n_pos)
title("Nyquist plot comparison for uncompensated system and with PI compensator")
legend("Uncompensated","PI compensator")
figure
step(kcl, kcl_PI)
title("Step response comparison for uncompensated system and with PI compensator")
legend("Uncompensated","PI compensator")
[M, q] = track_att(K_gain);
title("NIE UŻYWAĆ")
[M_PI, q_PI] = track_att(K_PI_gain);
title("NIE UŻYWAĆ")
figure
bodemag(M,M_PI)
xlim([0 5])
title("Tracking index comparison for uncompensated system and with PI compensator")
legend("Uncompensated","PI compensator")
figure
bodemag(q,q_PI)
xlim([0 5])
title("Attenuation index comparison for uncompensated system and with PI compensator")
legend("Uncompensated","PI compensator")
% C. Phase-lead (PD) compensation (𝐾𝑐(𝑠) = 1+𝑠𝑇 1+𝑠𝑇 𝛼 ): 
%     1. Assume 𝛼 = 4 and find the time constant T of the compensator, following the designing procedure. 
alpha = 4;
syms s w_star T
%solve(sqrt(alpha)/T == asin((alpha-1)/(alpha+1)))
%x = solve(atan(T*(sqrt(alpha)/T)) - atan(T/alpha*(sqrt(alpha)/T)) == asin((alpha-1)/(alpha+1)),T)
phi_c_max = asin((alpha-1)/(alpha+1))
phi_x = -pi - phi_c_max

clear s
syms s w_x kval
[Ks_num, Ks_den] = tfdata(K0);
K0s = poly2sym(cell2mat(Ks_num),s)/poly2sym(cell2mat(Ks_den),s);
w_x = vpa(solve([-atan(T1*w_x)-atan(T2*w_x)-atan(T3*w_x) == phi_x, w_x > 0],w_x))
w_x = max(real(w_x))

T = solve(sqrt(alpha)/T == w_x,T)
clear s
s = tf("s")
T = double(T)
PD = (1 + s * T) / (1 + s * T / alpha);
figure
nyquist(PD, n_pos)
figure
KPD = PD * K0;
nyquist(KPD, n_pos)
title("Nyquist plot for system with PD compensator and gain k = 1")
%     2. Find a critical gain 𝑘𝑐𝑟𝑖𝑡  for the compensated system.  
k_PD = critical_gain(KPD);
title("Root locus for system with PD compensator")
%     3. Calculate the gain k so that for the compensated system: Δ𝐴 = 2 (𝑜𝑟 Δ𝜑 = 𝜋 6) and print the Nyquist plot.
k_PD_val = gain_for_A2(KPD, T1, T2, T3, T, T/alpha)
K_PD_gain = nyquist_gain(KPD,k_PD_val);
title("Nyquist plot for system with PD compensator")
%     4. Plot the CL system step response. 
kcl_PD = closed_step(K_PD_gain)
title("Step response for system with PD compensator")
%     5. Plot the tracking index 𝑀(𝜔) and the attenuation index 𝑞(𝜔). ) and print the 
track_att(K_PD_gain)
%     6. Compare the characteristics for the uncompensated and PD-compensated systems. Discuss the properties of the phase-lead compensation.
figure
nyquist(K_gain,n_pos)
hold on
nyquist(K_PD_gain,n_pos)
title("Nyquist plot comparison for uncompensated system and with PD compensator")
legend("Uncompensated","PD compensator")
figure
step(kcl, kcl_PD)
title("Step response comparison for uncompensated system and with PD compensator")
legend("Uncompensated","PD compensator")
[M, q] = track_att(K_gain);
title("NIE UŻYWAĆ")
[M_PD, q_PD] = track_att(K_PD_gain);
title("NIE UŻYWAĆ")
figure
bodemag(M,M_PD)
xlim([0 5])
title("Tracking index comparison for uncompensated system and with PD compensator")
legend("Uncompensated","PD compensator")
figure
bodemag(q,q_PD)
xlim([0 5])
title("Attenuation index comparison for uncompensated system and with PD compensator")
legend("Uncompensated","PD compensator") 
% D. Compare the systems with the phase-lead and phase-lag compensation. Plot appropriate graphs. Draw conclusions. 
figure
nyquist(K_PI_gain,n_pos)
hold on
nyquist(K_PD_gain,n_pos)
title("Nyquist plot comparison for PI and PD compensators")
legend("PI compensator","PD compensator")
figure
step(kcl_PI, kcl_PD)
title("Step response comparison for PI and PD compensators")
legend("PI compensator","PD compensator")
figure
bodemag(M_PI,M_PD)
xlim([0 5])
title("Tracking index comparison for PI and PD compensators")
legend("PI compensator","PD compensator")
figure
bodemag(q_PI,q_PD)
xlim([0 5])
title("Attenuation index comparison for PI and PD compensators")
legend("PI compensator","PD compensator") 


function [Gm, Pm, Wcg, Wcp] = critical_gain(K)
rlocus(K)
[Gm,Pm,Wcg,Wcp] = margin(K);
%kcrit = Gm
end

function kval = gain_for_A2(K, T1, T2, T3, T4, T5)
%figure
%bode(K)
d_A = 2;
%w_pi = Wcg
%w_1 = Wcp
clear s
syms s w_pi_2 w_1_2 kval
[Ks_num, Ks_den] = tfdata(K);
K0s = poly2sym(cell2mat(Ks_num),s)/poly2sym(cell2mat(Ks_den),s);
w_pi_2 = vpa(solve(-atan(T1*w_pi_2)-atan(T2*w_pi_2)-atan(T3*w_pi_2)+atan(T4*w_pi_2)-atan(T5*w_pi_2)==-pi,w_pi_2 > 0,w_pi_2));
K_wpi = subs(K0s, s, j*w_pi_2)
K_gain = K_wpi*kval
kval = abs(vpa(solve(1/abs(K_gain) == 2,kval)))
kval = double(kval)
clear s w_pi_2 w_1_2
end

function K_gain = nyquist_gain(K, k)
s = tf("s");
K_gain = K*k;
figure
n_pos= nyquistoptions('cstprefs');
n_pos.ShowFullContour = 'off'; 
nyquist(K_gain,n_pos)
end

function Kcl = closed_step(K)
s = tf("s");
Kcl=K/(1+K);
figure
step(Kcl)
end

function [M, q] = track_att(K)
s = tf("s");
M = K/(1+K);
figure
bodemag(M)
xlim([0 5])
title("Tracking index 𝑀(𝜔)")
q = 1/(1+K);
figure
bodemag(q)
xlim([0 5])
title("Attenuation index 𝑞(𝜔)")
end