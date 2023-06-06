k = 2.5; T1 = 2; T2 = 1; T3 = 3.5; 
%k = 1.5; T1 = 2; T2 = 4; T3 = 1.5 %Tymon
%k = 2; T1 = 3.5; T2 = 2.5; T3 = 1; %Marcin
n_pos= nyquistoptions('cstprefs');
n_pos.ShowFullContour = 'off';
syms s
K0_num = k;
K0_den = (1+s*T1)*(1+s*T2)*(1+s*T3);
K0s = K0_num/K0_den;
clear s
s = tf("s");
K0 = k/((1+s*T1)*(1+s*T2)*(1+s*T3))
r = 50;

% Part I – Analysis of  CL systems 
%     1. Make root locus plot for a given CL system with a third order plant and  𝐾𝐶(𝑠)=𝑘 .  
rlocus(K0)
legend("kcrit = " + margin(K0))
title("Root locus plot of the plant")
%     2. Using the root locus plot find value of the critical gain kcr . Choose a controller gain k <kcr and find roots of the CL system characteristic equation. Calculate gain and phase margins. Explain the nature of the step response (aperiodic or oscillatory). Estimate settling time, frequency of oscillations, if any.
kcrit = margin(K0)
k_val = 0.5*kcrit
K = K0 * k_val
[K_num, K_den] = tfdata(K, "v");
char_eq = K_num + K_den;
roots_of_the_system = roots(char_eq)
figure
rlocus(K0)
hold on
scatter(real(roots_of_the_system),imag(roots_of_the_system),"d")
legend("","roots")
title("Roots of the closed-loop system for k = " + k_val)
text(real(roots_of_the_system(1)),imag(roots_of_the_system(1))+0.07,string(roots_of_the_system(1)))
text(real(roots_of_the_system(2))+0.03,imag(roots_of_the_system(2)),string(roots_of_the_system(2)))
text(real(roots_of_the_system(3))+0.03,imag(roots_of_the_system(3)),string(roots_of_the_system(3)))
figure
margin(K)
xlim([0 10])
title("Phase and gain margins of the closed-loop system")
allmargin(K)

%     3. Plot step response and compare values estimated in p.2 with simulation results. 
Kcl = K / (1 + K);
figure
step(Kcl)
title("Step response of the closed-loop system")
properties = stepinfo(Kcl)

%     4. Find value of k1 for which a stability degree is equal to a desired value 𝜂. Find a resonance degree for that case. Plot a CL system step response. 
time_rise = properties.PeakTime;
%eta = 1 / time_rise * log(r) WYJEBANE, wpisuję randomową wartość
% syms k1
% K1_den = subs(K0_den, s, 0)
% k1 = solve(K1_den + K0_num*k1 == 0, k1)
%eta = 0.114;
eta = 0.25
k1 = 0.63;
%resonance degree for k1 is 1.892
K = k1 * K0;
step_eta = K / (1 + K);
figure
step(step_eta)
title("Step response of the closed-loop system for 𝜂 = " + eta + " and k1 = " + k1)
%     5. Find value of k2 for which the resonance degree is equal to a desired value  𝜇. Find a stability degree for that case. Plot the CL system step response.
mu = 3.5;
k2 = 2.19;
%stability degree for k2 is 0.108
K = k2 * K0;
step_mu = K / (1 + K);
figure
step(step_mu)
title("Step response of the closed-loop system for 𝜇 = " + mu + " and k2 = " + k2)
%  Part II – Compensation in CL systems Note: Comparing overall gain in systems with different compensators remember how the gain is influenced by the compensator transfer function. 
%     6. For  𝐾𝐶(𝑠)=𝑘(1+𝑠𝑇𝑑) (PD controller) choose three values of Td . Check how an additional zero affects root locus plot and time responses. Present conclusions. 
kc = 1;
Td = [1/T1, k, 2*k];
KPD_1 = (kc * (1 + Td(1) * s)) * K0;
KPD_2 = (kc * (1 + Td(2) * s)) * K0;
KPD_3 = (kc * (1 + Td(3) * s)) * K0;
figure
p1 = subplot(3, 1, 1);
rlocus(KPD_1);
legend("kcrit = " + margin(KPD_1))
title("Root locus of the system with PD controller for T_d = " + Td(1))
p2 = subplot(3, 1, 2);
rlocus(KPD_2);
legend("kcrit = " + margin(KPD_2))
title("Root locus of the system with PD controller for T_d = " + Td(2))
p3 = subplot(3, 1, 3);
rlocus(KPD_3);
legend("kcrit = " + margin(KPD_3))
title("Root locus of the system with PD controller for T_d = " + Td(3))
linkaxes([p1 p2 p3],"xy")

PD1_step = KPD_1 / (1 + KPD_1);
PD2_step = KPD_2 / (1 + KPD_2);
PD3_step = KPD_3 / (1 + KPD_3);
figure
p1 = subplot(3, 1, 1);
step(PD1_step)
title("Step response of the closed-loop system with PD controller for T_d " + Td(1))
p2 = subplot(3, 1, 2);
step(PD2_step)
title("Step response of the closed-loop system with PD controller for T_d " + Td(2))
p3 = subplot(3, 1, 3);
step(PD3_step)
title("Step response of the closed-loop system with PD controller for T_d " + Td(3))
linkaxes([p1 p2 p3],"xy")

%     7. For 𝐾𝐶(𝑠)=𝑘(1+1 𝑠𝑇𝑖 ) (PI controller) choose three values of Ti . Check how an additional zero and pole at the origin affect root locus plot and time responses. Present conclusions. 
Ti = Td;
KPI_1 = (kc * (1 + 1/(Ti(1) * s))) * K0;
KPI_2 = (kc * (1 + 1/(Ti(2) * s))) * K0;
KPI_3 = (kc * (1 + 1/(Ti(3) * s))) * K0;
figure
p1 = subplot(3, 1, 1);
rlocus(KPI_1);
legend("kcrit = " + margin(KPI_1))
title("Root locus of the system with PI controller for T_i = " + Ti(1))
p2 = subplot(3, 1, 2);
rlocus(KPI_2);
legend("kcrit = " + margin(KPI_2))
title("Root locus of the system with PI controller for T_i = " + Ti(2))
p3 = subplot(3, 1, 3);
rlocus(KPI_3);
legend("kcrit = " + margin(KPI_3))
title("Root locus of the system with PI controller for T_i = " + Ti(3))
linkaxes([p1 p2 p3],"xy")

PI1_step = KPI_1 / (1 + KPI_1);
PI2_step = KPI_2 / (1 + KPI_2);
PI3_step = KPI_3 / (1 + KPI_3);
figure
p1 = subplot(3, 1, 1);
step(PI1_step)
title("Step response of the closed-loop system with PI controller for T_i " + Ti(1))
p2 = subplot(3, 1, 2);
step(PI2_step)
title("Step response of the closed-loop system with PI controller for T_i " + Ti(2))
p3 = subplot(3, 1, 3);
step(PI3_step)
title("Step response of the closed-loop system with PI controller for T_i " + Ti(3))
%linkaxes([p1 p2 p3],"xy")

%     8. For  𝐾𝐶(𝑠)=𝑘1+𝑠𝑇 1+𝑠𝛼𝑇 , and given  𝛼<1 (PD compensator) select time constant T so that one pole of the plant is simplified. Decide which one is the best choice. Plot root locus graph (use minreal Matlab command before you make RL plot). 
alpha = 1/4;
T_PD = [T2, T1, T3];
KPD_1 = minreal((kc * ((1 + T_PD(1) * s)/(1 + T_PD(1) * s * alpha))) * K0);
KPD_2 = minreal((kc * ((1 + T_PD(2) * s)/(1 + T_PD(2) * s * alpha))) * K0);
KPD_3 = minreal((kc * ((1 + T_PD(3) * s)/(1 + T_PD(3) * s * alpha))) * K0);
figure
p1 = subplot(3, 1, 1);
rlocus(KPD_1);
legend("kcrit = " + margin(KPD_1))
title("Root locus of the system with PD compensator for T_d = " + T_PD(1))
p2 = subplot(3, 1, 2);
rlocus(KPD_2);
legend("kcrit = " + margin(KPD_2))
title("Root locus of the system with PD compensator for T_d = " + T_PD(2))
p3 = subplot(3, 1, 3);
rlocus(KPD_3);
legend("kcrit = " + margin(KPD_3))
title("Root locus of the system with PD compensator for T_d = " + T_PD(3))
linkaxes([p1 p2 p3],"xy")
%     9. Find the gain k1 for which the stability degree is equal to a given value  𝜂 and k2 for which the resonance degree is equal to a given value  𝜇. Compare values to that obtained in p. 4 and 5. Plot step responses of both systems. 
T_selected = min(T_PD);
%(kc * ((1 + T_selected * s)/(1 + T_selected * s * alpha))) * K0 = k 
k1 = 3.03;
KC = k1 * (1 + T_selected * s) / (1 + alpha * T_selected * s);
K = KC * K0;
PD_eta = K / (1 + K);
figure
step(PD_eta)
title("Step response of the closed-loop system for T = " + T_selected + ", 𝜂 = " + eta + " and k1 = " + k1)
figure
step(step_eta)
hold on
step(PD_eta)
title("Comparison of step responses for 𝜂 = " + eta + " and k1 = " + k1)
legend("Uncompensated system","PD compensator")
k2 = 4.74;
KC = k2 * (1 + T_selected * s) / (1 + alpha * T_selected * s);
K = KC * K0;
PD_mu = K / (1 + K);
figure
step(PD_mu)
title("Step response of the closed-loop system for T = " + T_selected + ", 𝜇 = " + mu + " and k2 = " + k2)
figure
step(step_mu)
hold on
step(PD_mu)
title("Comparison of step responses for 𝜇 = " + mu + " and k2 = " + k2)
legend("Uncompensated system","PD compensator")

%     10. Repeat p.8 and p.9 for  𝐾𝐶(𝑠)=𝑘1+𝑠𝑇 1+𝑠𝑇 𝛼  (PI compensator).
T_PI = T_PD;
KPI_1 = minreal((kc * ((1 + T_PI(1) * s)/(1 + (T_PI(1) / alpha) * s))) * K0);
KPI_2 = minreal((kc * ((1 + T_PI(2) * s)/(1 + (T_PI(2) / alpha) * s))) * K0);
KPI_3 = minreal((kc * ((1 + T_PI(3) * s)/(1 + (T_PI(3) / alpha) * s))) * K0);
figure
p1 = subplot(3, 1, 1);
rlocus(KPI_1);
legend("kcrit = " + margin(KPI_1))
title("Root locus of the system with PI compensator for T_i = " + T_PI(1))
p2 = subplot(3, 1, 2);
rlocus(KPI_2);
legend("kcrit = " + margin(KPI_2))
title("Root locus of the system with PI compensator for T_i = " + T_PI(2))
p3 = subplot(3, 1, 3);
rlocus(KPI_3);
legend("kcrit = " + margin(KPI_3))
title("Root locus of the system with PI compensator for T_i = " + T_PI(3)) 
linkaxes([p1 p2 p3],"xy")
T_selected = max(T_PI);
k1 = 0.449;
KC = k1 * (1 + T_selected * s) / (1 + T_selected / alpha * s);
K = KC * K0;
PI_eta = K / (1 + K);
figure
step(PI_eta)
title("Step response of the closed-loop system for T = " + T_selected + ", 𝜂 = " + eta + " and k1 = " + k1)
figure
step(step_eta)
hold on
step(PI_eta)
title("Comparison of step responses for 𝜂 = " + eta + " and k1 = " + k1)
legend("Uncompensated system","PI compensator")

k2 = 5.35;
KC = k2 * (1 + T_selected * s) / (1 + T_selected / alpha * s);
K = KC * K0;
PI_mu = K / (1 + K);
figure
step(PI_mu)
title("Step response of the closed-loop system for T = " + T_selected + ", 𝜇 = " + mu + " and k2 = " + k2)
figure
step(step_mu)
hold on
step(PI_mu)
title("Comparison of step responses for 𝜇 = " + mu + " and k2 = " + k2)
legend("Uncompensated system","PI compensator")
%     11. Instead of the PI compensator insert a PI controller with parameters set according to Ziegler-Nichols rules. Calculate stability and resonance degrees. Compare step response with the previous ones. Draw conclusions. 
syms w_pi s
w_pi = vpa(solve([-atan(T1*w_pi)-atan(T2*w_pi)-atan(T3*w_pi)==-pi,w_pi > 0],w_pi))
k_c = 0.45 * kcrit
T_osc = vpa(2*pi()/w_pi)
T_i = double(0.85 * T_osc)
clear s
s = tf('s')
KPI_ZN = (k_c * (1 + 1/(T_i * s))) * K0
[K_num, K_den] = tfdata(KPI_ZN, "v");
char_eq = K_num + K_den;
roots_of_the_system = roots(char_eq)
return
ZN = KPI_ZN / (1 + KPI_ZN);
figure
step(ZN)
title("PI controller with Ziegler-Nichols parameters")
figure
hold on
step(step_mu,"cyan")
step(PD_mu,"magenta")
step(PI_mu,"yellow")
step(ZN,"black")
legend("Uncompensated, k = k2", "PD compensator, k = k2","PI compensator, k = k2", "PI controller with Ziegler-Nichols rules")
title("Comparison of step responses")

figure
hold on
step(step_eta,"cyan")
step(PD_eta,"magenta")
step(PI_eta,"yellow")
step(ZN,"black")
legend("Uncompensated, k = k1", "PD compensator, k = k1","PI compensator, k = k1", "PI controller with Ziegler-Nichols rules")
title("Comparison of step responses")