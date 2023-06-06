function int(X,Y,x)
s = numel(X);
W = 0;
str = strings(2*(s-1),s);
for i = 1:s
    w=1;
    a = 1;
    for n = 1:s
        if n~=i
            w=w*((x-X(n))/(X(i)-X(n)));
            str(a,i)= ['(x-' num2str(X(n)) ')'];
            str(2*s-a-1,i)=['(' num2str(X(i)) '-' num2str(X(n)) ')'];
            a=a+1;
        end
    end
    W=W+w*Y(i);
end
fprintf("W(x) = ")
for i = 1:s
        for n = 1:s-1
            fprintf('%s',str(n,i));
        end
        fprintf("/(");
        for n = 1:s-1
            fprintf('%s',str(2*s-n-1,i));
        end
        fprintf(')*%f ',Y(i));
        if i~=s
            fprintf('+ \n');
        end
end
fprintf('= %f \n',W);
end