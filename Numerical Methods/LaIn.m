function LaIn(x,y,spec_x)
n=length(x);
L=zeros(n,n);
fprintf("Find value of polynomial for x = %f\n",spec_x)
for i=1:n
    fprintf("Point P%d = (%f,%f)\n",i,x(i),y(i))
    P=1;
    for j=1:n
        if i~=j
           P=conv(P,poly(x(j)))/(x(i)-x(j));
        end
    end
    L(i,:)=P*y(i);
end
L
Eq=sum(L);
fprintf("\nEquation:\n")
for i=n-1:-1:2
    if(Eq(n-i)<0)      
        fprintf("(%fx^%d) + ",Eq(n-i),i)
    else
        fprintf("%fx^%d + ",Eq(n-i),i)
    end
end
if(Eq(n-1)<0)
    fprintf("(%fx) + ",Eq(n-1))
else
    fprintf("%fx + ",Eq(n-1))
end
if(Eq(n)<0)
    fprintf("(%f)",Eq(n))
else
    fprintf("%f",Eq(n))
end
Sol=sum(Eq);
fprintf("\n\nSolution:\nf(%f)=%f\n",spec_x,polyval(Eq,spec_x))
fplot(poly2sym(Eq))
hold on
plot(spec_x,polyval(Eq,spec_x),'r*')
