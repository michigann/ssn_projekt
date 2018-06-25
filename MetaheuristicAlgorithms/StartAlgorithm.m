function [best] = StartAlgorithm(algorithm, individual, fitnessFunction, iters, stopConditionFunction)
    agents=100; % Number of search agents
    lb = -1;
    ub = 1;
    dim = length(individual);
    params = {agents, iters, lb, ub, dim, stopConditionFunction};
    switch algorithm
        case 'cuttlefish'
            best = CuttleFishAlgorithm(params, fitnessFunction);
        case 'crow'
            best = CrowSearchAlgorithm(params, fitnessFunction);
        case 'grasshopper'
            best = GrasshopperAlgorithm(params, fitnessFunction);
    end
end