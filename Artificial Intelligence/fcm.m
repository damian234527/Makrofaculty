function fcm(varargin)
if nargin>0
X=varargin{1};
I=size(X,1);
N=size(X,2);
if nargin==4
    U=varargin{2};
    C=varargin{3};
    m=varargin{4};
elseif nargin==3
    C=varargin{2};
    m=varargin{3};
U = zeros(C, N);
c = 1;
for n = 1:N
U(c, n) = 1;
c = c + 1;
if c > C
c = 1;
end
end
U = U(:, randperm(size(U, 2)));
else
    fprintf("Invalid number of arguments\n")
    return;
end
else
      fprintf("No arguments specified\n")
    return;  
end
eps=10^-5;
K=I;
U_prev=0;
iteration=0;
end_condition=inf;
while end_condition>=eps 
for i=1:C
    for j=1:I    
        v(j,i)=sum(X(j,:).*U(i,:).^m)/sum(U(i,:).^m);
    end
end
v(isnan(v))=0;
for i=1:C
    for n=1:N
        d(i,n)=sqrt(sum((X(:,n)-v(:,i)).^2));
    end
end
J=sum(U.^m.*d.^2,"all");
U_prev=U;
for i = 1:C
for j = 1:N
U(i, j) = d(i, j).^(2/(1-m))/sum(d(:,j).^(2/(1-m)));
end
end
end_condition=norm(U-U_prev);
iteration=iteration+1;
end
fprintf("Iteration: %d\n",iteration);
U,v,J
scatter(X(1,:),X(2,:),"*")
hold on
scatter(v(1,:),v(2,:),".")
hold off