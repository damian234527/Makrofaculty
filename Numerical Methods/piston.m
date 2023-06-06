function piston(rpm,r)

%initial setup
step=5;
alpha_min=0-2*step;
alpha_max=360+2*step;
n=(alpha_max-alpha_min)/step;
alpha_min=deg2rad(alpha_min);
alpha_max=deg2rad(alpha_max);
step=deg2rad(step);

%preparing arrays
distance=zeros(n+1,1);
velocity=zeros(n+1,1);
acceleration=zeros(n+1,1);
time=zeros(n+1,1);
alpha=zeros(n+1,1);

omega=(pi*rpm)/30;
lambda=1/3.6;
l=r/lambda;


for j=1:(n+1)
    alpha(j)= alpha_min+(j-1)*step;
    time(j)=alpha(j)/omega;
end


for j=1:n+1
    distance(j)=r*(cos(alpha(j))+sqrt(1-(lambda^2)*sin(alpha(j))^2)/(lambda));
end

%calculation of the first derivative (velocity)
for j=2:n
    velocity(j)=(distance(j+1)-distance(j-1))/(time(j+1)-time(j-1));
end

%calculation of the second derivative (acceleration)
for j=3:n-1
    acceleration(j)=(velocity(j+1)-velocity(j-1))/(time(j+1)-time(j-1));
end

%finding maximum values and corresponding degree
%{
velocity_max=max(velocity);
velocity_index = find(velocity == velocity_max);
acceleration_max=max(acceleration);
acceleration_index = find(acceleration == acceleration_max);
%}
[velocity_max,velocity_index]=max(abs(velocity));
[acceleration_max,acceleration_index]=max(abs(acceleration));
%showing results
fprintf("\nMaximum velocity: %f m/s\nMaximum acceleration: %f m/s^2\n",velocity_max, acceleration_max);

%conversion of radians into degrees to present them on chart
for j=1:n+1
    alpha(j)=rad2deg(alpha(j));
end

%displaying a chart
hold on
xticks(0:15:360);
xlim([0 360]);
grid on

title("Piston velocity and acceleration");
yyaxis left;
plot(alpha, velocity, 'blue');
plot(alpha(velocity_index),velocity(velocity_index),"b*");
ylabel('velocity [m/s]');

yyaxis right;
plot(alpha,acceleration, 'red');
plot(alpha(acceleration_index),acceleration(acceleration_index),"r*")
ylabel('acceleration [m/s^2]');

xlabel('alpha [deg]');
