function ft = fitness(xn,N,pd) % Function for fitness evaluation
    for i=1:size(xn,1)
        ft(i)=sum(xn(i,:).^2); % Sphere function
    end
end