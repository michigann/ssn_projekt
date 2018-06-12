function [best] = StartAlgorithm(algorithm, fitnessFunction, stopConditionFunction, currentIndividual)
    agents=5; % Number of search agents
    lb = -1;
    dim = length(currentIndividual);
    ub = 1;
    iters=100; % Maximum numbef of iterations
    params = {agents, iters, lb, ub, dim, stopConditionFunction};
    switch algorithm
        case 'cuttlefish'
            best = CuttleFishAlgorithm(params, fitnessFunction);
        case 'crow'
            best = CrowSearchAlgorithm(params, fitnessFunction);
        case 'grasshopper'
            best = GrasshopperAlgorithm(params, fitnessFunction);
        otherwise  
            best = test(params, fitness);
    end
end

function best = test(params, fitness)
    params
    fitness(1, 2, 3);
    best = [];
end