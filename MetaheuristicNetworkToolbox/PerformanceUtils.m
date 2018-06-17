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
        
        function converted = convertResult(result)            
            converted = zeros(size(result));
            for i=1:size(result, 2)
               [maxValue, maxIndex] = max(result(:, i));
               converted(maxIndex, i) = 1;
            end
        end
    
    end
    
end

