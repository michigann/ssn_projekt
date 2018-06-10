function [best] = StartAlgorithm(algorithm, fitness)
    params = {};
    switch algorithm
        case 'cuttlefish'
            best = CuttleFishAlgorithm(params, fitness);
        case 'crow'
            best = CrowSearchAlgorithm(params, fitness);
        case 'grasshopper'
            best = GrasshopperAlgorithm(params, fitness);
        otherwise  
            best = test(params, fitness);
    end
end

function best = test(params, fitness)
    params
    fitness(1, 2, 3);
    best = [];
end