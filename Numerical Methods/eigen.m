function eigen(A, y0, n)
%eigen([1 1 1; 1 2 3;1 3 6],[1;0;0],3)

%Krylov method  
vector = y0;
y = zeros(n,n+1);
C = zeros(n,n);

y(:,1) = y0;

for i=2:(n+1)
       b = A*vector;
       y(:,i) = b;
       vector = b;
end

d = -y(:,n+1);

for i=1:n
    C(:,i) = y(:,n+1-i);
end

p = C^-1*d;
fprintf("Characteristic polynimial coefficients:\n");
disp(p);
number_intervals=1000;
x = linspace(-1,8,number_intervals);

f = x.^3+p(n-2)*x.^2+p(n-1)*x+p(n);
plot(x,f);
xlabel('lambda');
xlabel('Value of the function');
title('Seeking the roots - eigenvalues of matrix A');
grid on;
grid('minor');

disp('Determination of the eigenvalues by a function of Matlab - eigenvalues:');
eigenvalues = eig(A);
disp(eigenvalues);

disp('Determination of the eigenvectors by a function of Matlab - eigenvectros:');
[x,lambda] = eig(A);
disp('Eigenvectors without normalisation:');
disp(x);

disp('******************');
disp('Using eigenvalues as input for next calculations iterations are being done...');
g = zeros(n,n);
eigenvector = zeros(n,n);
for i = 1:n
    g(n,i) = 1;
    for k = (n-1):-1:1
        g(k,i) = lambda(i,i)*g(k+1,i)+p(n-k)*g(n,i);
    end
end
disp('Eigenvectors of matrix A worked out by a method from the handbook, pages 119-121:');
for i=1:n
    for j=1:n
        sum = 0;
        for k=1:n
            sum = sum+g(k,j)*y(i,k);
        end
        eigenvector(i,j) = sum;
    end
end
disp(eigenvector);


disp('******************');
disp('Comparison of the eigenvectors leads to a conclusion that:');
disp('Vectors are proportional ie. multiplied by a number!');
disp('******************');

disp('Normalisation according to the condition that the maximal component is equal 1:');
normalised_eigenvector = zeros(n,n);
for i=1:n
    number = max(abs(eigenvector(:,i)));
    normalised_eigenvector(:,i) = 1/number.*eigenvector(:,i);
end
disp(normalised_eigenvector);

%Power method

disp("POWER METHOD")
iter_num = n*length(A);
y_p = zeros(length(A),n);
y_p(:,1) = A*y0;
fprintf("\n");
fprintf("y0   %.12g   %.12g      %.12g\n",y0(1),y0(2),y0(3))
for i=1:iter_num
     y_p(:,i+1) = A*y_p(:,i);
     if mod(i,length(A)) == 0
            fprintf("y%i   ",i/length(A));
         fprintf("%.12g   %.12g      %.12g\n",y_p(i-2),y_p(i-1),y_p(i));
     end
end

eig_val_1 = y_p(iter_num)/y_p((n-1)*length(A));
eig_val_2 = y_p(iter_num-1)/y_p((n-1)*length(A)-1);
eig_val_3 = y_p(iter_num-2)/y_p((n-1)*length(A)-2);
fprintf("\nResults, obtained in the %i iteration: \n", i/length(A));
fprintf("%f\n%f\n%f\n",eig_val_1,eig_val_2,eig_val_3);

approx = (eig_val_1+eig_val_2+eig_val_3)/length(A);
fprintf("\nValue of the eigenvalue is: %.12g\n",approx);
fprintf("\nSolution: \ny(%i):\n%.12g\n%.12g\n%.12g\n",i/length(A),y_p(iter_num-2),y_p(iter_num-1),y_p(iter_num));

x1 = y_p(iter_num-2)/y_p(iter_num);
x2 = y_p(iter_num-1)/y_p(iter_num);
x3 = y_p(iter_num)/y_p(iter_num);
fprintf("\nAfter normalisation: \ny(%i):\n%.12g\n%.12g\n%.12g\n",i/length(A),x1,x2,x3);