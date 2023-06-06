function nle(f,a,b,eps)
max_iterations=200;
syms x;
assume(x>=a & x<=b);
disp("The analysed equation: ")
disp(f)
solution=solve(f,x);
if isempty(solution)
   fprintf("There is no root in this interval\n");
   return;
end
fprintf("The root in this interval = %s = %f\n",solution,solution)
hold on;
tiledlayout(1,3);
warning("off")

p1=nexttile;
fplot(f);
hold("on");
title("Bisection Method");
yline(0,"--")
xlim([a b])
xlabel("x")
ylabel("y")
grid on

p2=nexttile;
fplot(f);
hold("on");
title("Secant Method");
yline(0,"--")
xlim([a b])
xlabel("x")
ylabel("y")
grid on

p3=nexttile;
fplot(f);
hold("on");
title("Tangent Method");
yline(0,"--")
xlim([a b])
xlabel("x")
ylabel("y")
grid on


%bisection
b_a=a;
b_b=b;
for i=1:max_iterations
c=(b_a+b_b)/2;
yval=f(c);
if abs(yval)<=abs(eps)
    break
elseif f(b_a)*f(c)<0
    b_b=c;
else
    b_a=c;
end
plot(p1,c,yval,".g");
text(p1,c,yval,num2str(i),"FontSize",10);
end
fprintf("Bisection method: root = %.16g in iteration = %d, error = %.16g\n",c, i,c-solution)
plot(p1,c,yval,"*r")
text(p1,c,yval,"Solution");

%secant
s_a=a;
s_b=b;
for i=1:max_iterations
    if(f(s_a)*f(s_b))>=0
        sprintf("Secant method cannot find solution")
        break
    end
 xk=(s_a*f(s_b)-s_b*f(s_a))/(f(s_b)-f(s_a));
    x_points=[s_a s_b];
    y_points=[f(s_a) f(s_b)];
    parameters = [[1; 1]  x_points(:)]\y_points(:);
    line_equation=@(x) parameters(2)*x+parameters(1);
     if abs(f(xk))<=abs(eps) 
        break
     end
    plot(p2,[a-1000 b+1000],[line_equation(a-1000),line_equation(b+1000)],"Color",[0, 1, 1, 0.3]);
    text(p2,(s_a+s_b)/2,line_equation((s_a+s_b)/2),num2str(i));
 if f(s_a)*f(xk)<0
     s_b=xk;
 elseif f(s_b)*f(xk)<0
     s_a=xk;
 else
     break
 end
end
    fplot(p2,line_equation,"Color",[1, 0, 0]);
fprintf("Secant method: root = %.16g in iteration = %d, error = %.16g\n",xk, i,xk-solution)

%tangent
g= eval(['@(x)' char(diff(f(x)))]);
h= eval(['@(x)' char(diff(g(x)))]);
if f(a)*h(a)>0
    x0=a;
elseif f(b)*h(b)>0
    x0=b;
else
    n=0;
x0=a + (b-a).*rand;
while(f(x0)*h(x0)<=0)
    x0=a + (b-a).*rand;
    n=n+1;
    if(n>max_iterations^2)
        break;
    end
end
fprintf("Tangent method: a = %g and b = %g do not meet requirements, new point x0 = %g found\n",a, b,x0)
end
for i=1:max_iterations
    f0=f(x0); 
    g0=g(x0);
    xk=x0-f0/g0;
    tangent_equation=@(x) (f(x0)/(x0-xk))*(x-xk);
if abs(f(xk))<=abs(eps)
    break
end
      plot(p3,[a-1000 b+1000],[tangent_equation(a-1000),tangent_equation(b+1000)],"Color",[0, 1, 1, 0.3]);
      text(p3,(a+b)/2,tangent_equation((a+b)/2),num2str(i));
      x0=xk;
end
fplot(p3,tangent_equation,"Color",[1, 0, 0]);
fprintf("Tangent method: root = %.16g in iteration = %d, error = %.16g\n",xk, i,xk-solution)