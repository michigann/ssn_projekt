

function x=init(N,pd, l, u) % Function for initialization

x = zeros(N, pd);
for i=1:N % Generation of initial solutions (position of crows)
    for j=1:pd
        x(i,j)=l-(l-u)*rand; % Position of the crows in the space
    end
end
