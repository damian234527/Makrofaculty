function catenary(tension,weight,span)

%a parameter calculation
a = (tension/weight);

%Catenary equation;
Catenary = @(x)a*cosh(x/a); 

%height and length
height = a*cosh((span/2)/a);
length = 2*(sqrt(height.^2-a.^2));

fprintf("Value of a: %f\nLength of the line: %f m\n",a,length);

%plot creation
hold on;
title("Catenary plot")
xlabel("Span, m")
ylabel("Height, m")
fplot(Catenary);
xlim([-span/2 span/2]);
ylim([0 height]);
grid on;