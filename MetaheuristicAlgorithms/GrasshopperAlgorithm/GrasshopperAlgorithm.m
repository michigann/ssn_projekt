% The Grasshopper Optimization Algorithm
function BestPosition = GrasshopperAlgorithm(params, fobj)

    N = params{1};
    max_iter = params{2};
    lower = params{3};
    upper = params{4};
    dim = params{5};
    stopConditionFunction = params{6};
    
    cMax=1;
    cMin=0.00001;

    %Initialize the population of grasshoppers
    GrassHopperPositions=init(N,dim,upper,lower);
    %Calculate the fitness of initial grasshoppers
    GrassHopperFitness=fobj(GrassHopperPositions(:,:));

    BestFitness = GrassHopperFitness(1);
    BestPosition = GrassHopperPositions(1, :);
    for i=2:N
        if GrassHopperFitness(i) < BestFitness
            BestFitness = GrassHopperFitness(i);
            BestPosition = GrassHopperPositions(i, :);
        end
    end

    l=2;
    while l<max_iter+1
        
        c=cMax-l*((cMax-cMin)/max_iter); % Eq. (2.8) in the paper
        
        positions = GrassHopperPositions;
        for i=1:N
            S_i=zeros(1,dim);
            for j=1:N
                if i~=j
                    dist=distance(positions(j,:), positions(i, :)); % Calculate the distance between two grasshoppers

                    r_ij_vec=(positions(j,:)-positions(i,:))/(dist); % xj-xi/dij in Eq. (2.7)
                    xj_xi=2+rem(dist,2); % |xjd - xid| in Eq. (2.7) 

                    s_ij=((upper - lower)*c/2)*S_func(xj_xi).*r_ij_vec; % The first part inside the big bracket in Eq. (2.7)
                    S_i=S_i+s_ij;
                end
            end

            X_new = c * S_i + BestPosition; % Eq. (2.7) in the paper      
            GrassHopperPositions(i,:)=X_new; 
        end

        GrassHopperPositions(GrassHopperPositions > upper) = upper;
        GrassHopperPositions(GrassHopperPositions < lower) = lower;
        GrassHopperFitness=fobj(GrassHopperPositions(:,:));

        for i=1:N
            if GrassHopperFitness(i)<BestFitness
                BestPosition=GrassHopperPositions(i,:);
                BestFitness=GrassHopperFitness(i);
            end
        end

        if (stopConditionFunction(BestPosition, l-1))
           break; 
        end
        
        l = l + 1;
    
    end
    
end
