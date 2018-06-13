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




%% Old version

% % 
% % The Grasshopper Optimization Algorithm
% function BestPosition = GrasshopperAlgorithm(params, fitness)
% 
%     N = params{1};
%     max_iter = params{2};
%     lower = params{3};
%     upper = params{4};
%     dim = params{5};
%     stopConditionFunction = params{6};
%         
%     flag=0;
% 
%     if (rem(dim,2)~=0) % this algorithm should be run with a even number of variables. This line is to handle odd number of variables
%         dim = dim+1;
%         flag=1;
%     end
% 
%     GrassHopperPositions=init(N,dim,lower,upper);
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
%     % Find the best grasshopper (target) in the first population 
%     [sorted_fitness,sorted_indexes]=sort(GrassHopperFitness);
%     Sorted_grasshopper = GrassHopperPositions(sorted_indexes,:);
%     BestPosition=Sorted_grasshopper(1,:);
%     TargetFitness=sorted_fitness(1);
% 
%     % Main loop
%     l=2; % Start from the second iteration since the first iteration was dedicated to calculating the fitness of antlions
%     while l<max_iter+1
%         c=cMax-l*((cMax-cMin)/max_iter); % Eq. (2.8) in the paper
%         
%         positions = GrassHopperPositions;
%         for i=1:N
%             for k=1:2:dim
%                 S_i=zeros(1,2);
%                 for j=1:N
%                     if i~=j
%                         dist=distance(positions(j, k:k+1), positions(i, k:k+1)); % Calculate the distance between two grasshoppers
%                         r_ij_vec=(positions(j, k:k+1)-positions(i, k:k+1))/(dist+eps); % xj-xi/dij in Eq. (2.7)
%     
%                         xj_xi=2+rem(dist,2); % |xjd - xid| in Eq. (2.7) 
%     
%                         s_ij=((upper - lower)*c/2)*S_func(xj_xi)*r_ij_vec; % The first part inside the big bracket in Eq. (2.7)
%                         S_i=S_i+s_ij;
%                     end
%                 end
%                 S_i_total(:, k:k+1) = S_i;
% 
%             end
%             
%             GrassHopperPositions(i,:) = c * S_i_total+ (BestPosition); % Eq. (2.7) in the paper     
%         end
% 
%         for i=1:N
%             % Relocate grasshoppers that go outside the search space 
%             Tp=GrassHopperPositions(i,:)>upper;
%             Tm=GrassHopperPositions(i,:)<lower;
%             GrassHopperPositions(i,:)=(GrassHopperPositions(i,:).*(~(Tp+Tm)))+upper*Tp+lower*Tm;
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
% %         TODO: to w ramach testów, poprawê zostawiam dla Krzysia ;)
% %         zmiana na jak¹œ bardziej przystêpn¹ formê wywo³anai i
% %         sprawdzenie czy wgl jest jakiœ dodatkowy warunek - tak ¿eby
% %         ³adnie to wygl¹da³o i by³o bardziej uniwersalne
%         if (flag==1)
%             tmpBest = BestPosition(1:dim-1);
%         else
%             tmpBest = BestPosition;
%         end
%         
%         if (stopConditionFunction(tmpBest, l-1))
%            break; 
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

