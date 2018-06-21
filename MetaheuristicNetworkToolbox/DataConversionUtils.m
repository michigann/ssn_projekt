classdef DataConversionUtils

    methods (Static)
        
        function weights = weightsFromIndividual(net, individual)
            IW = net.IW;
            LW = net.LW;
            b = net.b;
            
            index = 1;
            
            s = size(IW);
            for i=1:s(1)
                s2 = size(IW{i});
                for j=1:s2(2)
                   for k=1:s2(1)
                       IW{i}(k, j) = individual(index);
                       index = index+1;
                   end
                end
            end
            
            s = size(LW);
            for i=1:s(1)
                for j=1:s(2)
                    if isempty(LW{i,j})
                        continue; 
                    end
                    s2 = size(LW{i,j});
                    for k=1:s2(2)
                       for l=1:s2(1)
                           LW{i,j}(l,k) = individual(index);
                           index = index+1;
                       end
                    end
                end
            end
            
            s = size(b);
            for i=1:s(1)
                for j=1:length(b{i})
                    b{i}(j) = individual(index);
                    index = index+1;
                end
            end
            
            weights.IW = IW;
            weights.LW = LW;
            weights.b = b;
        end
        
        function individual = individualFromWeights(net)
            IW = net.IW;
            LW = net.LW;
            b = net.b;
            
            individual = [];
            
            s = size(IW);
            for i=1:s(1)
                for j=IW{i}
                   individual = [individual j'];
                end
            end
           
            s = size(LW);
            for i=1:s(1)
                for j=1:s(2)
                    if isempty(LW{i,j})
                        continue; 
                    end
                    for k=LW{i,j}
                        individual = [individual k'];
                    end
                end
            end
            
            s = size(b);
            for i=1:s(1)
                individual = [individual b{i}'];
            end
        end
        
        function class = convertNetworkResultToClass(result)
            if size(result, 1) > 1
                class = zeros(size(result));
                for l=1:size(result, 2)
                    [~, maxIndex] = max(result(:, l));
                    class(maxIndex, l) = 1;
                end
            else
                class = round(result);
            end     
        end
        
        function data = normData(r)
            data = mapstd(r);
        end
        
    end
    
end
