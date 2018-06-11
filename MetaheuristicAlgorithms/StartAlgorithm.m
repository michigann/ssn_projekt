function [best] = StartAlgorithm(algorithm, fitness)
    agents=20; % Number of search agents
    dim = 10;
    lb = -100;
    ub = 100;
    iters=2000; % Maximum numbef of iterations
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