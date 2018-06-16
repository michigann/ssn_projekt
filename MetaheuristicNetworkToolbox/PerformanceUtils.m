classdef PerformanceUtils
    
    methods (Static)
        
        function differences = getDifferences(result, expected)
            equalityMatrix = result == expected;
            differences = 0;
            for i=1:size(equalityMatrix, 2)
                if sum(equalityMatrix(:, i)) ~= size(result, 1)
                    differences = differences + 1;
                end
            end
        end
    
    end
    
end

