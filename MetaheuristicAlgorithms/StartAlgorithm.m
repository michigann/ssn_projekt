function [best] = StartAlgorithm(algorithm, fitness, currentIndividual)
    agents=5; % Number of search agents
    lb = -1;
    dim = length(currentIndividual);
    ub = 1;
    iters=100; % Maximum numbef of iterations
    params = {agents, iters, lb, ub, dim};
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