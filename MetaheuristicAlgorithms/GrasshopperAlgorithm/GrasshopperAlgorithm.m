% % 
% % The Grasshopper Optimization Algorithm
function BestPosition = GrasshopperAlgorithm(params, fitness)

    N = params{1};
    max_iter = params{2};
    lower = params{3};
    upper = params{4};
    dim = params{5};
        
    flag=0;

    if (rem(dim,2)~=0) % this algorithm should be run with a even number of variables. This line is to handle odd number of variables
        dim = dim+1;
        flag=1;
    end

    GrassHopperPositions=init(N,dim,lower,upper);

    cMax=1;
    cMin=0.00001;

    %Calculate the fitness of initial grasshoppers
    if flag == 1
        GrassHopperFitness = fitness(GrassHopperPositions(:, 1:end-1));
    else
        GrassHopperFitness = fitness(GrassHopperPositions);
    end
    
    % Find the best grasshopper (target) in the first population 
    [sorted_fitness,sorted_indexes]=sort(GrassHopperFitness);
    Sorted_grasshopper = GrassHopperPositions(sorted_indexes,:);
    BestPosition=Sorted_grasshopper(1,:);
    TargetFitness=sorted_fitness(1);

    % Main loop
    l=2; % Start from the second iteration since the first iteration was dedicated to calculating the fitness of antlions
    while l<max_iter+1
        c=cMax-l*((cMax-cMin)/max_iter); % Eq. (2.8) in the paper
        
        positions = GrassHopperPositions;
        for i=1:N
            for k=1:2:dim
                S_i=zeros(1,2);
                for j=1:N
                    if i~=j
                        dist=distance(positions(j, k:k+1), positions(i, k:k+1)); % Calculate the distance between two grasshoppers
                        r_ij_vec=(positions(j, k:k+1)-positions(i, k:k+1))/(dist+eps); % xj-xi/dij in Eq. (2.7)
    
                        xj_xi=2+rem(dist,2); % |xjd - xid| in Eq. (2.7) 
    
                        s_ij=((upper - lower)*c/2)*S_func(xj_xi)*r_ij_vec; % The first part inside the big bracket in Eq. (2.7)
                        S_i=S_i+s_ij;
                    end
                end
                S_i_total(:, k:k+1) = S_i;

            end
            
            GrassHopperPositions(i,:) = c * S_i_total+ (BestPosition); % Eq. (2.7) in the paper     
        end

        for i=1:N
            % Relocate grasshoppers that go outside the search space 
            Tp=GrassHopperPositions(i,:)>upper;
            Tm=GrassHopperPositions(i,:)<lower;
            GrassHopperPositions(i,:)=(GrassHopperPositions(i,:).*(~(Tp+Tm)))+upper*Tp+lower*Tm;
        end

        if flag == 1
            GrassHopperFitness = fitness(GrassHopperPositions(:, 1:end-1));
        else
            GrassHopperFitness = fitness(GrassHopperPositions);
        end

        for i=1:N      
            % Update the target
            if GrassHopperFitness(i)<TargetFitness
                BestPosition=GrassHopperPositions(i,:);
                TargetFitness=GrassHopperFitness(i);
            end
        end

        l = l + 1;
    end


    if (flag==1)
        BestPosition = BestPosition(1:dim-1);
    end

end









%% TEST IMPLEMENTATION - TO CHECK

% 
% % The Grasshopper Optimization Algorithm
% function BestPosition = GrasshopperAlgorithm(params, fitness)
% 
%     N = params{1};
%     max_iter = params{2};
%     lower = params{3};
%     upper = params{4};
%     dim = params{5};
%         
%     flag=0;
%     ub=ones(dim,1)*upper;
%     lb=ones(dim,1)*lower;
% 
%     if (rem(dim,2)~=0) % this algorithm should be run with a even number of variables. This line is to handle odd number of variables
%         dim = dim+1;
%         ub = [ub; upper];
%         lb = [lb; lower];
%         flag=1;
%     end
% 
% 
%     GrassHopperPositions=init(N,dim,lower,upper);
%     GrassHopperFitness = zeros(N, 1);
% 
%     cMax=1;
%     cMin=0.00001;
% 
%     %Calculate the fitness of initial grasshoppers
%     if flag == 1
%         GrassHopperFitness = fitness(GrassHopperPositions(:, 1:end-1));
%     else
%         GrassHopperFitness = fitness(GrassHopperPositions);
%     end
% 
%     [sorted_fitness,sorted_indexes]=sort(GrassHopperFitness);
% 
% 
%     % Find the best grasshopper (target) in the first population 
%     for newindex=1:N
%         Sorted_grasshopper(newindex,:)=GrassHopperPositions(sorted_indexes(newindex),:);
%     end
% 
%     BestPosition=Sorted_grasshopper(1,:);
%     TargetFitness=sorted_fitness(1);
% 
%     % Main loop
%     l=2; % Start from the second iteration since the first iteration was dedicated to calculating the fitness of antlions
%     while l<max_iter+1
%         c=cMax-l*((cMax-cMin)/max_iter); % Eq. (2.8) in the paper
%         positions = GrassHopperPositions;
%         for i=1:N
%             for j=1:N
%                 if i==j
%                     continue
%                 end
%                 summary = 0;
%                 dist = distance(positions(j, :), positions(i, :));
%                 r = positions(j, :) - positions(i, :);
%                 xjd_xid = 2+rem(dist,2);
%                 s = S_func(xjd_xid);
%                 summary  = summary + c * ((upper - lower) / 2) * s .* (r / dist); 
%             end
%             GrassHopperPositions(i, :) = c * summary + BestPosition;
%         end
% 
% 
%         for i=1:size(GrassHopperPositions,1)
%             % Relocate grasshoppers that go outside the search space 
%             Tp=GrassHopperPositions(i,:)>ub';
%             Tm=GrassHopperPositions(i,:)<lb';
%             GrassHopperPositions(i,:)=(GrassHopperPositions(i,:).*(~(Tp+Tm)))+ub'.*Tp+lb'.*Tm;
%         end
% 
%         if flag == 1
%             GrassHopperFitness = fitness(GrassHopperPositions(:, 1:end-1));
%         else
%             GrassHopperFitness = fitness(GrassHopperPositions);
%         end
% 
%         for i=1:N     
%             % Update the target
%             if GrassHopperFitness(i)<TargetFitness
%                 BestPosition=GrassHopperPositions(i,:);
%                 TargetFitness=GrassHopperFitness(i);
%             end
%         end
% 
%         l = l + 1;
%     end
% 
% 
%     if (flag==1)
%         BestPosition = BestPosition(1:dim-1);
%     end
% 
% end

