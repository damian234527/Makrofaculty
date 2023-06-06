function diff_eq(g,x0,y0,xn,n,Picard_iterations)
%diff_eq(@(x,y) 2*x.*y,0,1,0.9,9,3)
%diff_eq(@(x,y) x.^2-y.^2,0,0,1,10,3)
%diff_eq(@(x,y) exp(x)-y.^2,0,0,1,10,3)
%diff_eq(@(x,y) euler(1,x)-y.^2,0,0,1,10,3)

%Numerical solution
syms y(x)
sym_g=sym(g);
sym_g=subs(sym_g,y,y(x));
ode = diff(y,x) == sym_g;
cond = y(x0) == y0;
ySol(x) = dsolve(ode,cond);
ySol(x)=real(ySol(x));
f= eval(['@(x)' char(ySol(x))]);

h=abs(x0+xn)/n;

%Euler method
x_vals=zeros(n+1,1);
y_e=zeros(n+1,1);
x_vals(1)=x0;
y_e(1)=y0;
for i=1:n
    x_vals(i+1)=x_vals(i)+h;
    y_e(i+1)=y_e(i)+h*g(x_vals(i),y_e(i));
end

%Broken lines method
xi=zeros(n,1);
yi=zeros(n,1);
y_improved_1=zeros(n,1);
for i=1:n
    xi(i)=h/2+x_vals(i);
    yi(i)=y_e(i)+(h/2)*g(x_vals(i),y_e(i));
    if i>1
        y_improved_1(i)=y_improved_1(i-1)+h*g(xi(i),yi(i));
    else
        y_improved_1(1)=y_e(1)+h*g(xi(i),yi(i));
    end
end

%Euler-Cauchy method
y_improved_2=zeros(n,1);
yii=zeros(n,1);
yii(1)=y_e(1);
for i=1:n
    yii(i+1)=y_e(i)+h*g(x_vals(i),y_e(i));
    if i>1
        y_improved_2(i)=y_improved_2(i-1)+(h/2)*(g(x_vals(i),y_e(i))+g(x_vals(i+1),yii(i+1)));
    else
        y_improved_2(1)=y_e(i)+(h/2)*(g(x_vals(i),y_e(i))+g(x_vals(i+1),yii(i+1)));
    end
end

%Runge-Kutta method
y_rk=zeros(n+1,1);
y_rk(1)=y_e(1);
for i=1:n
    k1 = g(x_vals(i),y_rk(i));
    k2 = g(x_vals(i)+(h/2),y_rk(i)+(h/2)*k1);
    k3 = g((x_vals(i)+(h/2)),(y_rk(i)+(h/2)*k2));
    k4 = g((x_vals(i)+h),(y_rk(i)+k3*h));
    y_rk(i+1) = y_rk(i) + (1/6)*(k1+2*k2+2*k3+k4)*h;
    
end

%Picard method
syms fp(x,z) y
%Picard_iterations=input("Specify number of iterations for Picard method: ");
sym_p=sym(g);
sym_p=subs(sym_p,y,z);
fp=sym_p;
ysub = y0;
for i=1:Picard_iterations
f_p = y0 + int(subs(fp,z,ysub),0,x);
ysub = f_p;
if (i<Picard_iterations)
    syms z
end
end

f_p=matlabFunction(f_p);
y_p=zeros(n+1,1);
y_p(1)=y_e(1);
for i=2:n+1
   y_p(i)=f_p(x_vals(i)); 
end

%Actual results
y_real=zeros(n+1,1);
for i=1:n+1
    y_real(i)=f(x_vals(i));
end

y_improved_1=[y_e(1); y_improved_1];
y_improved_2=[y_e(1); y_improved_2];

%calculating the errors
err_e=zeros(n+1,1);
err_i1=zeros(n+1,1);
err_i2=zeros(n+1,1);
err_rk=zeros(n+1,1);
err_p=zeros(n+1,1);
for i=2:n+1
    err_e(i)=y_e(i)-y_real(i);
    err_i1(i)=y_improved_1(i)-y_real(i);
    err_i2(i)=y_improved_2(i)-y_real(i);
    err_rk(i)=y_rk(i)-y_real(i);
    err_p(i)=y_p(i)-y_real(i);
end

err_e_sum=sum(abs(err_e));
err_i1_sum=sum(abs(err_i1));
err_i2_sum=sum(abs(err_i2));
err_rk_sum=sum(abs(err_rk));
err_p_sum=sum(abs(err_p));

%RESULTS

%making plots
hold on;

warning("off")
%ezplot(f,[x0 xn]) %used when function f had imaginary unit, no longer needed because of taking only real part (i was very small, 3^-18, probably error in computations
fplot(f,"Color","r")
warning("on")
plot(x_vals,y_e,"Color","k","LineStyle",":")
plot(x_vals,y_improved_1,"Color","k","LineStyle","--")
plot(x_vals,y_improved_2,"Color","k")
plot(x_vals,y_rk,"Color","b")
fplot(f_p,"Color","g")
%ezplot(f_p,[x0 xn])

xlim([x0 xn])
minus_f=@(x) -f(x);
y_lower=real(f(fminbnd(f,x0,xn)));
y_upper=real(f(fminbnd(minus_f,x0,xn)));
y_range=abs(y_upper-y_lower);
y_limits=sort([y_lower-y_range/10 y_upper+y_range/10],"ascend");
ylim(y_limits)
title("Approximate solving of ordinary differential equation")
legend("Function plot","Euler method","Broken lines method","Euler-Cauchy method","Runge-Kutta method","Picard method");

%creating table

%data and errors table
solution=table(x_vals(2:end),y_real(2:end), y_e(2:end), err_e(2:end), y_improved_1(2:end), err_i1(2:end), y_improved_2(2:end), err_i2(2:end), y_rk(2:end),err_rk(2:end),y_p(2:end),err_p(2:end));
solution=renamevars(solution,["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9","Var10","Var11","Var12"],["x","y","Euler method","E error","Broken lines method","BL error","Euler-Cauchy method","EC error","Runge-Kutta method","RK error","Picard method","P error"]);
disp(solution)

%sum of |errors| for each method
sum_of_errors=table(err_e_sum,err_i1_sum,err_i2_sum,err_rk_sum,err_p_sum);
sum_of_errors=renamevars(sum_of_errors,["err_e_sum","err_i1_sum","err_i2_sum","err_rk_sum","err_p_sum"],["Euler error summed","Broken lines error summed","Euler-Cauchy error summed","Runge-Kutta error summed","Picard error summed"]);
disp(sum_of_errors)

%mean of |errors| for each method
mean_of_errors=table(err_e_sum/n,err_i1_sum/n,err_i2_sum/n,err_rk_sum/n,err_p_sum/n);
mean_of_errors=renamevars(mean_of_errors,["Var1","Var2","Var3","Var4","Var5"],["Euler error mean","Broken lines error mean","Euler-Cauchy error mean","Runge-Kutta error mean","Picard error mean"]);
disp(mean_of_errors)

f_str=func2str(f);
if contains(f_str,"i")
    f_str=f_str(5:end);
else
    f_str=f_str(9:end);
end
f_p_str=func2str(f_p);
f_p_str=f_p_str(5:end);

fprintf("\n               Function equation: %s",f_str);
fprintf("\n Picard's approximation equation: %s\n",f_p_str);