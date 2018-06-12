function d = distance(a,b)
    sum = 0;
    for dim=1:length(a)
        sum = sum + (a(dim) - b(dim)) ^ 2;
    end
    d=sqrt(sum);
end