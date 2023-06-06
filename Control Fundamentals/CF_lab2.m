syms s
K2_num = 4;
K2_den = (1+s)*(1+(11/3)*s);
%K2_den = (1+s)*(1+(7/3)*s);
K2 = K2_num/K2_den;

K3_num = 1.5;
K3_den = s*(1+s)*(1+(11/3)*s);
K3 = K3_num/K3_den;

%Second order
%K2=4/((1+s)*(1+(11/3)*s))
%Open loop analysis
    %1. For a given second order system described by transfer function K(s):
        % a) write its characteristic equation;
        ch_eq_open = K2_den
        % b) find roots of the characteristic equation and discuss system stability;
        roots_open = solve(ch_eq_open,s);
        % c) assuming zero input signal and an initial condition 𝑦(0) = 𝑦0;𝑦(0) = 𝑦0  find analytical form and plot time response  𝑦(𝑡)  of the system. 
        K2tf_den = sym2poly(K2_den);
        K2tf=tf(K2_num,K2tf_den);
        
        s = tf('s');
        Y2 = @(y0, dy0) (y0 * ((11/3) * s + (14/3)) + (11/3) * dy0) / ((11/3) * s^2 + (14/3) * s + 1);        
        figure
        hold on
        impulse(Y2(1,2))
        impulse(Y2(1,-2))
        impulse(Y2(1,1))
        impulse(Y2(-1,-2))
        title("y(t)")
        legend("y(0) = 1, y'(0) = 2","y(0) = 1, y'(0) = -2","y(0) = 1, y'(0) = 1","y(0) = -1, y'(0) = -2")

 clear s       
%Closed loop analysis
syms s
    %2. Assuming gain k1=1: 
        %a) write a characteristic equation of the system 
        ch_eq_closed = K2_num+K2_den;
        % b) find roots of the characteristic equation and on the s-plane present roots of the open and closed loop systems;
        roots_closed = solve(ch_eq_closed,s);
        roots_closed_p = [real(roots_closed)'; imag(roots_closed)'];
        figure
        hold on
        scatter(roots_closed_p(1,:),roots_closed_p(2,:),"*")
        pzplot(K2tf)
        clear s 
        % c) assuming r(t)=0 and initial condition 𝑒(0) = 𝑒0;𝑒(0) = 𝑒0 find analytical form of time response 𝑒(𝑡);
        s = tf('s');
        E2 = @(e0, de0) (e0 * ((11/3) * s + (14/3)) + (11/3) * de0) / ((11/3) * s^2 + (14/3) * s + 5);
        
        % d) plot the time responses 𝑒(𝑡) for several selected initial conditions, comment results;     
        figure
        hold on      
        impulse(E2(1,2))
        impulse(E2(1,-2))
        impulse(E2(1,1))
        impulse(E2(-1,-2))
        title("e(t)")
        legend("e(0) = 1, e'(0) = 2","e(0) = 1, e'(0) = -2","e(0) = 1, e'(0) = 1","e(0) = -1, e'(0) = -2")
        % e) discuss system stability;
        
        % f) use Nyquist criterion to check stability of the system.
        figure
        nyquist(K2tf)
        title("2.f Nyquist plot")
    %3. Using Hurwitz criterion determine the range of the gain k1 that guarantees system stability.
    %4. Plot root locus of the system. Discuss stability. 
    figure
    rlocus(K2tf)
    
    title("4. & 5. Root locus")
    hold on
    %5. Mark on the root locus roots corresponding to k1=1. Compare them to the values obtained in pt. 2b.
    scatter(roots_closed_p(1,:),roots_closed_p(2,:),"*")
    ylimits = double(roots_closed_p(2,:)).*1.1;
    ylim(ylimits)
    clear s
%Third order
syms s
%K3=1.5/(s*(1+s)*(1+(11/3)*s))
    %6. For a given transfer function of the third order system:
        %a) write characteristic equation;
        ch_eq_3 = K3_num + K3_den;
        roots_3 = vpa(solve(ch_eq_3,s));
        
        kcrit = 0.8484848484848484848484848484;
        clear s
        %b) using Hurwitz criterion determine the range of the gain k1 that guarantees system stability;
        
        %c) assuming r(t)=0 for a selected initial condition 𝑦(0) = 𝑦0; 𝑦̇(0) = 𝑦̇0; 𝑦̈(0) = 𝑦̈0 and k1=0.5k1crit, , calculate and plot time response 𝑦(𝑡) of the system.
        s = tf('s');
        Y3 = @(y0, dy0, ddy0) (y0 * ((11/3) * s^2 + (14/3) * s + 1) + dy0 * ((11/3)*s + (14/3)) + (11/3) * ddy0) / ((11/3)*s^3+(14/3)*s^2+s+0.636);
        figure
        hold on
        impulse(Y3(1,1,1)*kcrit/2)
        impulse(Y3(2,1,1)*kcrit/2)
        impulse(Y3(1,2,1)*kcrit/2)
        impulse(Y3(1,1,2)*kcrit/2)
        legend("y(0) = 1, y'(0) = 1, y''(0) = 1","y(0) = 2, y'(0) = 1, y''(0) = 1","y(0) = 1, y'(0) = 2, y''(0) = 1","y(0) = 1, y'(0) = 1, y''(0) = 2")
        
        %d) for the critical gain and two other values of the gain (less and greater than critical one) draw Nyquist plots (in one graph) and discuss stability;
        K3tf=tf(K3_num,sym2poly(K3_den));
        figure
        hold on
        nyquist(K3tf*kcrit, K3tf*kcrit*0.5, K3tf*kcrit*1.5)
        legend("k = kcrit","k = 0.5*kcrit","k = 1.5*kcrit")

        %e) plot root locus of the system and mark critical gain k1crit. Discuss influence of the gain value k1 on the location of roots of the characteristic equation;  
        figure
        rlocus(K3tf)
        hold on
        roots_3_p = zeros(3,2);
        roots_3_p(1,:) = [0,0.522];
        roots_3_p(2,:) = [0,-0.522];
        roots_3_p(3,:) = [real(roots_3(3,:))*kcrit', imag(roots_3(3,:))*kcrit'];
        roots_3_p
        scatter(roots_3_p(:,1),roots_3_p(:,2),"*")
        
        %f) using root locus plot choose two different gains for which characteristic equation of the system has 3 real roots, and two different gains for which characteristic equation of the system has one real and 2 complex roots. For these four gains plot step responses of the closed loop system.
        k1=0.01;
        k2=0.03;
        k3=0.4;
        k4=0.8;

        figure
        subplot(2,2,1)
        step(K3tf/(1+K3tf*k1))
        title("Step response for k = 0.01")
        subplot(2,2,2)
        step(K3tf/(1+K3tf*k2))
        title("Step response for k = 0.03")
        subplot(2,2,3)
        step(K3tf/(1+K3tf*k3))
        title("Step response for k = 0.4")
        subplot(2,2,4)
        step(K3tf/(1+K3tf*k4))
        title("Step response for k = 0.8")

        K11 = feedback(K3tf * k1,1)
        K12 = feedback(K3tf * k2,1)
        K13 = feedback(K3tf * k3,1)
        K14 = feedback(K3tf * k4,1)

        figure
        subplot(2,2,1)
        step(K11)
        title("Test response for k = 0.01")
        subplot(2,2,2)
        step(K12)
        title("Test response for k = 0.03")
        subplot(2,2,3)
        step(K13)
        title("Test response for k = 0.4")
        subplot(2,2,4)
        step(K14)
        title("Test response for k = 0.8")

        %g) discuss influence of the gain k1 on time responses of the system (e.g.: condition for oscillations in time responses of the system).
        k5=0.5*kcrit;
        k6=1.5*kcrit;
        figure
        subplot(3,1,1)
        Kclosed1=K3tf/(1+K3tf*k5);
        step(Kclosed1)
         title("Step response for k = 0.5kcrit")
        subplot(3,1,2)
        Kclosed2=K3tf/(1+K3tf*kcrit);
        step(Kclosed2)  
         title("Step response for k = kcrit")
        subplot(3,1,3)
        Kclosed3=K3tf/(1+K3tf*k6);
        step(Kclosed3)
         title("Step response for k = 1.5kcrit")