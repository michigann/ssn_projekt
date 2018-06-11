
% The Grasshopper Optimization Algorithm
function BestPosition = GrasshopperAlgorithm(params, fitness)

    N = params{1};
    max_iter = params{2};
    lower = params{3};
    upper = params{4};
    dim = params{5};
        
    flag=0;
    ub=ones(dim,1)*upper;
    lb=ones(dim,1)*lower;

    if (rem(dim,2)~=0) % this algorithm should be run with a even number of variables. This line is to handle odd number of variables
        dim = dim+1;
        ub = [ub; upper];
        lb = [lb; lower];
        flag=1;
    end


    GrassHopperPositions=init(N,dim,lower,upper);
    GrassHopperFitness = zeros(1,N);

    cMax=1;
    cMin=0.00001;

    %Calculate the fitness of initial grasshoppers
    if flag == 1
        GrassHopperFitness(1, :) = fitness(GrassHopperPositions(:, 1:end-1), N, dim-1);
    else
        GrassHopperFitness(1, :) = fitness(GrassHopperPositions, N, dim);
    end

    [sorted_fitness,sorted_indexes]=sort(GrassHopperFitness);


    % Find the best grasshopper (target) in the first population 
    for newindex=1:N
        Sorted_grasshopper(newindex,:)=GrassHopperPositions(sorted_indexes(newindex),:);
    end

    BestPosition=Sorted_grasshopper(1,:);
    TargetFitness=sorted_fitness(1);

    GrassHopperPositions_temp = zeros(size(GrassHopperPositions));
    % Main loop
    l=2; % Start from the second iteration since the first iteration was dedicated to calculating the fitness of antlions
    while l<max_iter+1
        c=cMax-l*((cMax-cMin)/max_iter); % Eq. (2.8) in the paper

        for i=1:size(GrassHopperPositions,1)
            temp= GrassHopperPositions';
            for k=1:2:dim
                S_i=zeros(2,1);
                for j=1:N
                    if i~=j
                        Dist=distance(temp(k:k+1,j), temp(k:k+1,i)); % Calculate the distance between two grasshoppers

                        r_ij_vec=(temp(k:k+1,j)-temp(k:k+1,i))/(Dist+eps); % xj-xi/dij in Eq. (2.7)
                        xj_xi=2+rem(Dist,2); % |xjd - xid| in Eq. (2.7) 

                        s_ij=((ub(k:k+1) - lb(k:k+1))*c/2)*S_func(xj_xi).*r_ij_vec; % The first part inside the big bracket in Eq. (2.7)
                        S_i=S_i+s_ij;
                    end
                end
                S_i_total(k:k+1, :) = S_i;

            end
            X_new = c * S_i_total'+ (BestPosition); % Eq. (2.7) in the paper      
            GrassHopperPositions_temp(i,:)=X_new'; 
        end
        % GrassHopperPositions
        GrassHopperPositions=GrassHopperPositions_temp;


        for i=1:size(GrassHopperPositions,1)
            % Relocate grasshoppers that go outside the search space 
            Tp=GrassHopperPositions(i,:)>ub';
            Tm=GrassHopperPositions(i,:)<lb';
            GrassHopperPositions(i,:)=(GrassHopperPositions(i,:).*(~(Tp+Tm)))+ub'.*Tp+lb'.*Tm;
        end

        if flag == 1
            GrassHopperFitness(1, :) = fitness(GrassHopperPositions(:, 1:end-1), N, dim-1);
        else
            GrassHopperFitness(1, :) = fitness(GrassHopperPositions, N, dim);
        end

        for i=1:size(GrassHopperPositions,1)        
            % Update the target
            if GrassHopperFitness(1,i)<TargetFitness
                BestPosition=GrassHopperPositions(i,:);
                TargetFitness=GrassHopperFitness(1,i);
            end
        end

        l = l + 1;
    end


    if (flag==1)
        BestPosition = BestPosition(1:dim-1);
    end

end

