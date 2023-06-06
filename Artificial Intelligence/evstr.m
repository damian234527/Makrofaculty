%(µ + λ)
%evstr("ES_data_3",100,200,5,0.0000001,1)
function evstr(filename,population_size,generation_max,offspring_per_parent,max_difference,max_results)
clc
table = readtable(filename);
x=table2array(table(:,1)); %assigning first column from data file to x
y=table2array(table(:,2)); %assigning second column to y
solution=zeros(max_results,7); %setting size of solution matrix

tau_1=1/sqrt(2*6);  %n=6
tau_2=1/sqrt(2*sqrt(6));

for results=1:max_results %repeating execution of the code to obtain several solutions at once (to chceck correctness)
tic; %time counting
f= @(a,b,c,x) a*(x.^2-b*cos(x*c*pi)); %function equation

%figure("units","normalized","outerposition",[0 0 1 1]) %set figure (plot) to open in fullscreen
%scatter(x,y,".") %plot points from data file
%hold on

%First Parents
Parents=zeros(population_size,7); 
Parents(:,1:6)=[-10 + 20.*rand(population_size,3) 10.*rand(population_size,3)]; %uniformly distributed random numbers; first 3 numbers from -10 to 10, the last 3 from 0 to 10
for i=1:population_size
   Parents(i,7) = mean((y-f(Parents(i,1), Parents(i,2),Parents(i,3),x)).^2); %value of mean squared error
end
    %Offspring
    for generation=1:generation_max
        Offsprings=repmat(Parents,offspring_per_parent,1); % copies Parents matrix rows by number of mutations per parent
        for i=1:population_size*offspring_per_parent                     
            r_sigma_1=randn()*tau_1; %normally distributed value from 0 to tau_1

            for j=1:3
            r_sigma_2=randn()*tau_2; %normally distributed value from 0 to tau_2
            Offsprings(i,j)=Offsprings(i,j)+randn()*Offsprings(i,j+3);
            Offsprings(i,j+3)=Offsprings(i,j+3)*exp(r_sigma_1)*exp(r_sigma_2);                  
            end
            
            Offsprings(i,7) = mean((y-f(Offsprings(i,1), Offsprings(i,2),Offsprings(i,3),x)).^2);       
        end
Offsprings = sortrows(Offsprings,7);    %sorting by mean squared error in ascending order
Parents = sortrows(Parents,7);          %sorting by mean squared error in ascending order

difference=Parents(1,7)-Offsprings(1,7); 
if abs(difference) < max_difference %checking if difference in MSE between parent and offspring is lower than acceptable
  if difference<0 %error of Offsprings best result is bigger
   solution(results,:)=Parents(1,:);
  else
   solution(results,:)=Offsprings(1,:); %error of Parents best result is bigger
  end
  break; %end loop for current execution if difference is lower
end
Parents=Offsprings(1:population_size,:); %assign Parents for next iteration (generation)
solution(results,:)=Offsprings(1,:);
    end
time(results,:)=toc; %stop the count!
    %Printing result of the last execution in command window
    fprintf("Iteration: %d \na = %g \nb = %g \nc = %g \nerror = %g\ntime = %g\n\n\n",generation,solution(results,1:3),solution(results,7),time(results,:));

    %PLOT FOR GIVEN 'a', 'b' AND 'c'
    f= @(x) solution(results,1)*(x.^2-solution(results,2)*cos(x*solution(results,3)*pi));
    %title("Evolution strategy population size = " + population_size + "   offspring per parent = " + offspring_per_parent + "   generation = " + generation,"FontSize",18)
    
    %values of a,b,c, error and time displayed in bottom right of the plot
    values_on_plot={"a = " + solution(results,1),"b = " + solution(results,2),"c = " + solution(results,3),"error = " + solution(results,7),"time = " + time(results)};   
    %xl=xlim;
    %yl=ylim;
    %text(xl(2)*0.95,yl(1)+yl(2)*0.05,values_on_plot,"HorizontalAlignment","right","VerticalAlignment","bottom","FontSize",12)
   
    %fplot(f)
    %hold off
    generations(results,:)=generation; %number of generations needed to find solution
end
%TABLE OF EVERY EXECUTION
solution_table=array2table(solution,"VariableNames",["a","b","c","sigma a","sigma b","sigma c","Mean squared error"]);
solution_table.time=time;
solution_table.generation=generations;
solution_table=movevars(solution_table,"generation","Before","a");
fprintf("Table of %d results for population size = %d and offspring per parent = %d\n",max_results,population_size,offspring_per_parent);
disp(solution_table);
end