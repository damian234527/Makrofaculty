%proxy([0; 2.5;5.5;8.5;11],[0.03;0.9;2.8;4.7;6.3],2)
%proxy("NM 6 Approximation","A2:A6","B2:B6",2)
%proxy("NM 6 Approximation","J2:J10","K2:K10",2)
%proxy("NM 6",2)
%proxy(@(x) cos(x),2,5,10,2)
%proxy("multiple",[0.042; 0.043; 0.042; 0.042; 0.04; 0.042; 0.041; 0.05; 0.058;0.038],[0.18; 0.18; 0.2; 0.2; 0.23; 0.18; 0.23; 0.2; 0.19; 0.23],[0.008; 0.008; 0.005; 0.005; 0.009; 0.008; 0.009; 0.008; 0.008; 0.01],[0.005; 0.005; 0.006; 0.006; 0.007; 0.005; 0.007; 0.006; 0.006; 0.006],[114; 114; 112; 110; 116; 114; 114; 114; 117; 100])

function proxy(varargin)
if isstring(varargin{1}) && varargin{1}=="multiple"
    n=length(varargin{2});
    X=ones(n,nargin-1);
    for i=1:nargin-2
        X(:,i+1)=varargin{i+1};
    end
    y=varargin{nargin};
p=(X'*X)^-1*X'*y;
u_str(:,1)=p(2:end);
u_str(:,2)=1:1:size(X,2)-1;
approximation_equation_string = join(compose("%g*u%g",u_str)," + ");
approximation_equation_string = "z = "+ p(1) + " + " + approximation_equation_string;
disp(approximation_equation_string)
return
else
    if nargin==5

f=varargin{1};
a=varargin{2};
b=varargin{3};
n=varargin{4};
degree=varargin{5};

x=sort((b-a).*rand(n,1)+a,"ascend");
y=f(x);
elseif nargin==4

filename=varargin{1};
range_x=varargin{2};
range_y=varargin{3};
degree=varargin{4};

x = readmatrix(filename,'Range',range_x);
y = readmatrix(filename,'Range',range_y);

elseif nargin==3
x=varargin{1};
y=varargin{2};
degree=varargin{3};
elseif nargin==2
        isstring(varargin{1});
        filename=varargin{1};
        table = readtable(filename);
        x=table2array(table(:,1));
        y=table2array(table(:,2));
        degree=varargin{2};
else
    fprintf("Wrong number of arguments\n")
    return;
end
n= length(x);
if n ~= length(y)
    fprintf("Number of x and y is not equal, please change your input\n")
    return;
end
if degree>=n
    degree=n-1;
    fprintf("Degree of desired polynomial is too big, Applied degree = %d (number of points - 1)\n\n",degree);
end
X=ones(n,2);
X(:,2)=x;
for i=3:degree+1
new_column=x.^(i-1);
X(:,i)=new_column;
end
p=vpa((X'*X)^-1*X'*y);
p=double(p);
pd=p/p(1);
approximation_equation_string="p(1) + p(2)*x";
approximation_display_string= p(1) + " + " + p(2) +"*x";
approximation_display_string_2= p(1) + " * ( " + pd(1)+(" + ")+pd(2) +"*x";
if length(p)>2
Eq_nums(:,1)=3:length(p);
Eq_nums(:,2)=2:length(p)-1;
p_val(:,1)=p(3:end);
p_val(:,2)=2:length(p)-1;
pd_val(:,1)=pd(3:end);
pd_val(:,2)=2:length(p)-1;
approximation_equation_string = approximation_equation_string + " + " + join(compose("p(%d)*x.^%d", Eq_nums)," + ");
approximation_display_string = approximation_display_string + " + " +  join(compose("%d*x^%d", p_val)," + ");
approximation_display_string_2 = approximation_display_string_2 + (" + ") + join(compose("%d*x^%d", pd_val)," + ") + (")");
else
    approximation_display_string_2=approximation_display_string_2 + ")";
end

approximation_equation= eval(['@(x)' char(approximation_equation_string)]);
approx_y=approximation_equation(x);
hold on;
fplot(approximation_equation,"LineStyle",":");
scatter(x,y);
if degree==1
    title("Approximation line based on " + n + " points")
else
    title("Approximation curve of polynomial of the " + degree + " degree based on " + n + " points")
end
x_reserve=abs((x(1)-x(n))/10);
xlim([x(1)-x_reserve x(n)+x_reserve])
xlabel("x");
y_reserve=abs((min(y)-max(y))/10);
y_limits=[min(y)-y_reserve max(y)+y_reserve];
ylim(y_limits);
ylabel("y");
fprintf("p:\n");
disp(p);
fprintf("\nSolution:\n");
disp(approximation_display_string);
disp(approximation_display_string_2)
approx_error=zeros(n:1);
for i=1:n
approx_error(i)=abs(((y(i)-approx_y(i))/y(i)))*100;
fprintf("The approximation error for point %d: %.3g%% \n",i,approx_error(i));
end
fprintf("The approximation error mean: %.3g%% \n\n",sum(approx_error)/n);
end