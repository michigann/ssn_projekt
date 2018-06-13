function d = distance(a,b)
    s = sum((a - b).^2);
    d=sqrt(s);
end