function [best] = StartAlgorithm(algorithm, individual, fitnessFunction, stopConditionFunction)
    agents=50; % Number of search agents
    lb = -1;
    ub = 1;
    dim = length(individual);
    iters=9999999999; % Maximum number of iterations
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