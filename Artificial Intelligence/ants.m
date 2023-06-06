function ants(num_of_ants,distance1,distance2)
k=20;
d=2;
A1=0;
A2=0;
P1=(A1+k)^d/((A1+k)^d+(A2+k)^d);
r=rand;
if(r<P1)
    A1=A1+1;
else
    A2=A2+1;
end
for i=2:num_of_ants
P1=(A1+k)^d/((A1+k)^d+(A2+k)^d)*(distance2/distance1);
P2=1-P1;
r=rand;
if(r<P1)
    A1=A1+1;
else
    A2=A2+1;
end
end
fprintf("Number of ants that went left = %d\nNumber of ants that went right = %d\n",A1,A2);