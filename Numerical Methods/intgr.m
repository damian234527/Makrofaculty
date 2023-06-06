%intgr(inline('cos(x)'),pi/6,pi/2,2)
%intgr(@(x)cos(x),pi/6,pi/2,20)
%intgr(@(x)1./(1+x.^2),0,1,15)
%intgr(@(x)8./x,-15,-3,30)

function intgr(f,a,b,n)
warning("off");

%analytical
Solan= integral(f,a,b);
fprintf("\n The value of integration for analytical method is %f",Solan);

%preparation of plots
tiledlayout(2,1);
p1=nexttile;
p2=nexttile;
fplot(p1,f,[a b],"red","LineWidth",2);
fplot(p2,f,[a b],"red","LineWidth",2);
hold(p1,"on");
hold(p2,"on");
title(p1,"Trapezoidal Method");
title(p2,"Rectangular Method");

h = (b-a)/n;
%trapezoidal
st=0;
x=zeros(1,n+1);
ys=zeros(1,n+1);
x(1)=a;
ys(1)=f(a);
x(n+1)=b;
ys(n+1)=f(b);
for i=2:1:n
  x(i)=a+(i-1)*h;
  ys(i)=f(x(i));
  st=st+ys(i);
end
for i=1:1:n
 plot(p1,polyshape([x(i),x(i),x(i+1),x(i+1)],[0,ys(i),ys(i+1),0]),"FaceColor",[0.6,1,1]);
end
Solt=h/2*(f(a)+f(b)+2*st);
fprintf("\n The value of integration for trapezoidal method is %f, error = %f",Solt,Solt-Solan);  

%rectangular - Midpoint
sr=0;
for i =0:n-1
    xn= a + (i * h+h/2);
    yn=f(xn);
    sr = sr + f(xn);
     plot(p2,polyshape([xn-h/2,xn-h/2,xn+h/2,xn+h/2],[0,yn,yn,0]),"FaceColor",[0.6,1,1]);
end
Solr = h * sr;
fprintf("\n The value of integration for rectangular method is %f, error = %f",Solr, Solr-Solan);

%Simpson's
o = 0;
e = 0;
for i = 1:2:n
    xs=a+(i*h);
    o=o+f(xs);
end
for i = 2:2:n-1
    xs=a+(i*h);
    e=e+f(xs);
end
yb=f(a)+f(b);
Sols = (h/3)*(yb+4*o+2*e);
fprintf("\n The value of integration for Simpson's method is %f, error = %f",Sols,Sols-Solan); 