function y = hornerscheme(x,Coeff)
    y = 0;
    Coeff=flip(Coeff);
    Arr=Coeff;
    for i = (numel(Coeff):-1:1)
        y = (y * x) + Coeff(i);
        Arr(i)=y;
    end
    flip(Arr)
end
