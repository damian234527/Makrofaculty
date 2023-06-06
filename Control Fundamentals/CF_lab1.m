%CAD of Control Systems  - Matlab
%Do it for given K(s)
%K(s)=k/(s(1+sT)^2)
% T - number of section
% I. Continuous-time model 
    % Open-loop system analysis:
    fprintf("I. Continuous-time model \n    Open-loop system analysis:")
    s = tf('s');
    %K=1/(1+5*s)^3
    K=1/(s*(1+11*s)^2)
    step(K)
    waitforbuttonpress
    figure
    nyquist(K)
    waitforbuttonpress
    figure
    bode(K)
    waitforbuttonpress
    w=0.1;
    A=2;
    Gsin=A*w/(w^2+s^2)
    figure
    impulse(Gsin*K)
    waitforbuttonpress
    figure
    step(K,0:0.1:5)
    waitforbuttonpress
    waitforbuttonpress

    % Closed loop sysem analysis:
    fprintf("I. Continuous-time model \n    Open-loop system analysis:")
    figure
    rlocus(K)
    kcrit=0.183;
    k=0.8*kcrit;
    waitforbuttonpress
    figure
    nyquist(K*k);
    waitforbuttonpress
    figure
    margin(K*k);
    Kclosed=K/(1+K*k);
    waitforbuttonpress
    figure
    step(Kclosed)
    minreal(Kclosed)
    waitforbuttonpress
    figure
    bode(Kclosed)
%     %Only Bode magnitude plot
%     figure
%     bodemag(Kclosed)

% II. Discrete-time system 
%Do it for given K(s)
%K(s)=k/(1+sT) 
% T - number of section
    % Open-loop system analysis:
    fprintf("II. Discrete-time system \n    Open-loop system analysis:")
    %K2=1/(1+s);
    K2=1/(1+11*s)
    Kz= c2d(K2,0.2,"zoh") 
    figure
    step(Kz)
    waitforbuttonpress
%     figure
%     stem(step(Kz))
    [Y, T]=step(Kz)
    
    figure
    stem(T,Y)
    waitforbuttonpress
    figure
    nyquist(Kz)
    waitforbuttonpress
    figure
    bode(Kz)
    waitforbuttonpress
    figure
    rlocus(Kz)
    waitforbuttonpress
    kcrit=110.01;
    k=0.8*kcrit;
    Kzc=Kz/(1+Kz*k);
    [Y, T]=step(Kzc)
    figure
    stem(T,Y)
 