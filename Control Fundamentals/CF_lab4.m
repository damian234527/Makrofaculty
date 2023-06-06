k = 2.5; T1 = 2; T2 = 1; T3 = 3.5
%k = 1.5; T1 = 1.5; T2 = 3; T3 = 3.5

syms s
K0_num = k;
K0_den = (1+s*T1)*(1+s*T2)*(1+s*T3);
K0s = K0_num/K0_den
clear s
s = tf('s')
K0 = k/((1+s*T1)*(1+s*T2)*(1+s*T3))
kr = 1;
Kr = kr;
K = kr*K0;
disp(K);

% 1. Find the critical gain value kcrit 
rlocus(K)
r9 = -1/T1 - 1/T2 - 1/T3
kcrit = margin(K)
%kcrit = 4.24;
% 2. Choose two values of the gain of the proportional controller k1 = 0.35 kcrit  and  k2 = 0.8 kcrit. Proceed with all following points with each controller separately. 
kr1 = 0.35*kcrit;
kr2 = 0.8*kcrit;
K1 = kr1*K0;
K2 = kr2*K0;
% 3. Assuming z(t) = 0, find the steady state error for w(t) = 1(t) 
W = 1/s;
E1=W*1/(1+K1);
figure
impulse(E1)
title("Time response e(t) for kr = 0.35kcrit")
[E_num1, E_den1] = tfdata(E1)
E2=W*1/(1+K2);
figure
impulse(E2)
title("Time response e(t) for kr = 0.8kcrit")
[E_num2, E_den2] = tfdata(E2)
clear s
syms s
Es1 = poly2sym(cell2mat(E_num1),s)/poly2sym(cell2mat(E_den1),s);
ess1 = double(limit(s*Es1,s,0))
Es2 = poly2sym(cell2mat(E_num2),s)/poly2sym(cell2mat(E_den2),s);
ess2 = double(limit(s*Es2,s,0))
% 4. Plot the tracking index M(𝜔), defined in the following way: 𝑀(𝜔) =| 𝐾(𝑗𝜔) 1+𝐾(𝑗𝜔) | = 𝑌(𝑗𝜔) 𝑊(𝑗𝜔) 
M1 = K1/(1+K1)
figure
bodemag(M1)
title("Tracking index M(𝜔) for kr = 0.35kcrit")
figure
M2 = K2/(1+K2)
bodemag(M2)
title("Tracking index M(𝜔) for kr = 0.8kcrit")
% 5. Compare the steady state error calculated in point 3 to the value of M(0). 
[M1s_num, M1s_den] = tfdata(M1);
M1s = poly2sym(cell2mat(M1s_num),s)/poly2sym(cell2mat(M1s_den),s);
M1s = vpa(subs(M1s,s,0))

[M2s_num, M2s_den] = tfdata(M2);
M2s = poly2sym(cell2mat(M2s_num),s)/poly2sym(cell2mat(M2s_den),s);
M2s = vpa(subs(M2s,s,0))

% 6. Choose three frequency values: ω1 - from the passband, ω2 - from the stopband and ω3 - from the resonance band, noting corresponding values M(ω1), M(ω2), M(ω3). For each frequency plot the system steady state responses to the input signals w(t) = A sin(ωxt). Observe their magnitudes. Discuss the results. 
[mag, phase, freq] = bode(M1);
vals = [squeeze(freq), squeeze(mag)];
[w2, idx_w2] = max(squeeze(mag));
f_w2 = vals(idx_w2,1);
idx_w1=fix(idx_w2/2);
f_w1 = vals(idx_w1,1);
w1 = vals(idx_w1,2);
idx_w3 = fix(3*(length(vals)-idx_w2)/8) + idx_w2;
f_w3 = vals(idx_w3,1);
w3 = vals(idx_w3,2);
figure
bodemag(M1)
hold on
plot(f_w1,w1,"*","Color","r","MarkerSize",10)
plot(f_w2,w2,"*","Color","r","MarkerSize",10)
plot(f_w3,w3,"*","Color","r","MarkerSize",10)
title("M(𝜔) for kr = 0.35kcrit with 𝜔1, 𝜔2 and 𝜔3 marked")
legend("","ω1 = " + round(f_w1,3) + " M(𝜔1) = " + round(w1,3),"ω2 = " + round(f_w2,3) + " M(𝜔2) = " + round(w2,3),"ω3 = " + round(f_w3,3) + " M(𝜔3) = " + round(w3,3))

[mag, phase, freq] = bode(M2);
vals = [squeeze(freq), squeeze(mag)];
[w2_2, idx_w2_2] = max(squeeze(mag));
f_w2_2 = vals(idx_w2_2,1);
idx_w1_2=fix(idx_w2_2/2);
f_w1_2 = vals(idx_w1_2,1);
w1_2 = vals(idx_w1_2,2);
idx_w3_2 = fix(3*(length(vals)-idx_w2_2)/8) + idx_w2_2;
f_w3_2 = vals(idx_w3_2,1);
w3_2 = vals(idx_w3_2,2);
figure
bodemag(M2)
hold on
plot(f_w1_2,w1_2,"*","Color","r","MarkerSize",10)
plot(f_w2_2,w2_2,"*","Color","r","MarkerSize",10)
plot(f_w3_2,w3_2,"*","Color","r","MarkerSize",10)
title("M(𝜔) for kr = 0.8kcrit with 𝜔1, 𝜔2 and 𝜔3 marked")
legend("","ω1 = " + round(f_w1_2,3) + " M(𝜔1) = " + round(w1_2,3),"ω2 = " + round(f_w2_2,3) + " M(𝜔2) = " + round(w2_2,3),"ω3 = " + round(f_w3_2,3) + " M(𝜔3) = " + round(w3_2,3))

clear s
s = tf("s")

A = 1;
Ksin1 = A * w1 / (w1^2 + s^2);
Ksin2 = A * w2 / (w2^2 + s^2);
Ksin3 = A * w3 / (w3^2 + s^2);
figure
sin1_1 = subplot(3,1,1);
impulse(Ksin1 * M1)
title("Steady state response to the sinusoidal input signal for 𝜔1 and kr = 0.35kcrit")
sin1_2 = subplot(3,1,2);
impulse(Ksin2 * M1)
title("Steady state response to the sinusoidal input signal for 𝜔2 and kr = 0.35kcrit")
sin1_3 = subplot(3,1,3);
impulse(Ksin3 * M1)
title("Steady state response to the sinusoidal input signal for 𝜔3 and kr = 0.35kcrit")
linkaxes([sin1_1 sin1_2 sin1_3],"x")
xlim([0 400])

Ksin1_2 = A * w1_2 / (w1_2^2 + s^2);
Ksin2_2 = A * w2_2 / (w2_2^2 + s^2);
Ksin3_2 = A * w3_2 / (w3_2^2 + s^2);
figure
sin2_1 = subplot(3,1,1);
impulse(Ksin1_2 * M2)
title("Steady state response to the sinusoidal input signal for 𝜔1 and kr = 0.8kcrit")
sin2_2 = subplot(3,1,2);
impulse(Ksin2_2 * M2)
title("Steady state response to the sinusoidal input signal for 𝜔2 and kr = 0.8kcrit")
sin2_3 = subplot(3,1,3);
impulse(Ksin3_2 * M2)
title("Steady state response to the sinusoidal input signal for 𝜔3 and kr = 0.8kcrit")
linkaxes([sin2_1 sin2_2 sin2_3],"x")
xlim([0 200])

% 7. Compare shapes of the tracking index as well as the system responses obtained for different values of gain kr. Draw conclusions. 
figure
bodemag(M1)
hold on
bodemag(M2)
title("Comparison of M(𝜔) for kr = 0.35kcrit and 0.8kcrit")
legend("kr = 0.35kcrit","kr = 0.8kcrit")
% 8. Assuming  w(t) = 0, find the steady state error for z(t) = 1(t). 
clear s
s = tf("s")
Z = 1/s;
E1_2=Z*K0/(1+K1);
figure
impulse(E1_2)
title("Time response e(t) for kr = 0.35kcrit")
[E_num1, E_den1] = tfdata(E1_2)
E2_2=Z*K0/(1+K2);
figure
impulse(E2_2)
title("Time response e(t) for kr = 0.8kcrit")
[E_num2, E_den2] = tfdata(E2_2)
clear s
syms s
Es1_2 = poly2sym(cell2mat(E_num1),s)/poly2sym(cell2mat(E_den1),s);
ess1_2 = double(limit(s*Es1_2,s,0))
Es2_2 = poly2sym(cell2mat(E_num2),s)/poly2sym(cell2mat(E_den2),s);
ess2_2 = double(limit(s*Es2_2,s,0))
% 9. Plot the attenuation index q(ω), defined in the following way: 𝑞(𝜔) = |1/1+𝐾(𝑗𝜔)| = |𝐸𝑐𝑙(𝑗𝜔)/𝐸𝑜(𝑗𝜔)|
q1 = 1/(1+K1)
figure
bodemag(q1)
title("q(ω) for kr = 0.35kcrit")
[K1_num, K1_den] = tfdata(K1);
K1s = poly2sym(cell2mat(K1_num),s)/poly2sym(cell2mat(K1_den),s);
[K2_num, K2_den] = tfdata(K2);
K2s = poly2sym(cell2mat(K2_num),s)/poly2sym(cell2mat(K2_den),s);
q2 = 1/(1+K2)
figure
bodemag(q2)
title("q(ω) for kr = 0.8kcrit")
% 10. Compare the steady state error calculated in point 8 to the value of q(0). 
q1_0 = vpa(subs(1/(1+K1s),s,0))
q1_0_2 = 1/(1+2.5*kr1)
return
q1_0 = vpa(subs(1/(1+K2s),s,0))
% 11. Choose three frequency values: ω1 - from the attenuation band, ω2 - from over resonance and ω3 – from the resonance band, noting corresponding values q(ω1), q(ω2), q(ω3). For each frequency plot the system steady state responses to the input signals z(t) = Asin(ωxt). Observe their magnitudes. Discuss the results.
[mag, phase, freq] = bode(q1);
vals = [squeeze(freq), squeeze(mag)];
[w2, idx_w2] = max(squeeze(mag));
f_w2 = vals(idx_w2,1);
idx_w1=fix(idx_w2/2);
f_w1 = vals(idx_w1,1);
w1 = vals(idx_w1,2);
idx_w3 = fix((length(vals)-idx_w2)/2) + idx_w2;
f_w3 = vals(idx_w3,1);
w3 = vals(idx_w3,2);
figure
bodemag(q1)
hold on
plot(f_w1,w1,"*","Color","r","MarkerSize",10)
plot(f_w2,w2,"*","Color","r","MarkerSize",10)
plot(f_w3,w3,"*","Color","r","MarkerSize",10)
title("q(𝜔) for kr = 0.35kcrit with 𝜔1, 𝜔2 and 𝜔3 marked")
legend("","ω1 = " + round(f_w1,3) + " q(𝜔1) = " + round(w1,3),"ω2 = " + round(f_w2,3) + " q(𝜔2) = " + round(w2,3),"ω3 = " + round(f_w3,3) + " q(𝜔3) = " + round(w3,3))

[mag, phase, freq] = bode(q2);
vals = [squeeze(freq), squeeze(mag)];
[w2_2, idx_w2_2] = max(squeeze(mag));
f_w2_2 = vals(idx_w2_2,1);
idx_w1_2=fix(idx_w2_2/2);
f_w1_2 = vals(idx_w1_2,1);
w1_2 = vals(idx_w1_2,2);
idx_w3_2 = fix((length(vals)-idx_w2_2)/2) + idx_w2_2;
f_w3_2 = vals(idx_w3_2,1);
w3_2 = vals(idx_w3_2,2);
figure
bodemag(q2)
hold on
plot(f_w1_2,w1_2,"*","Color","r","MarkerSize",10)
plot(f_w2_2,w2_2,"*","Color","r","MarkerSize",10)
plot(f_w3_2,w3_2,"*","Color","r","MarkerSize",10)
title("q(𝜔) for kr = 0.8kcrit with 𝜔1, 𝜔2 and 𝜔3 marked")
legend("","ω1 = " + round(f_w1_2,3) + " q(𝜔1) = " + round(w1_2,3),"ω2 = " + round(f_w2_2,3) + " q(𝜔2) = " + round(w2_2,3),"ω3 = " + round(f_w3_2,3) + " q(𝜔3) = " + round(w3_2,3))

clear s
s = tf("s")

Ksin1 = A * w1 / (w1^2 + s^2);
Ksin2 = A * w2 / (w2^2 + s^2);
Ksin3 = A * w3 / (w3^2 + s^2);
figure
sin1_1 = subplot(3,1,1);
impulse(Ksin1 * q1)
title("Steady state response to the sinusoidal input signal for 𝜔1 and kr = 0.35kcrit")
sin1_2 = subplot(3,1,2);
impulse(Ksin2 * q1)
title("Steady state response to the sinusoidal input signal for 𝜔2 and kr = 0.35kcrit")
sin1_3 = subplot(3,1,3);
impulse(Ksin3 * q1)
title("Steady state response to the sinusoidal input signal for 𝜔3 and kr = 0.35kcrit")
linkaxes([sin1_1 sin1_2 sin1_3],"x")
xlim([0 100])

Ksin1_2 = A * w1_2 / (w1_2^2 + s^2);
Ksin2_2 = A * w2_2 / (w2_2^2 + s^2);
Ksin3_2 = A * w3_2 / (w3_2^2 + s^2);
figure
sin2_1 = subplot(3,1,1);
impulse(Ksin1_2 * q2)
title("Steady state response to the sinusoidal input signal for 𝜔1 and kr = 0.8kcrit")
sin2_2 = subplot(3,1,2);
impulse(Ksin2_2 * q2)
xlim([0 12])
title("Steady state response to the sinusoidal input signal for 𝜔2 and kr = 0.8kcrit")
sin2_3 = subplot(3,1,3);
impulse(Ksin3_2 * q2)
title("Steady state response to the sinusoidal input signal for 𝜔3 and kr = 0.8kcrit")
linkaxes([sin2_1 sin2_3],"x")
xlim([0 120])

% 12. Compare shapes of the attenuation index as well as the system responses obtained for different values of gain kr. Draw conclusions.
figure
bodemag(q1)
hold on
bodemag(q2)
title("Comparison of q(𝜔) for kr = 0.35kcrit and 0.8kcrit")
legend("kr = 0.35kcrit","kr = 0.8kcrit")
