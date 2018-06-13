clear all 
clc

agents=20; % Number of search agents
dim = 8;
lb = -1;
ub = 1;
iters=1000; % Maximum numbef of iterations
params = {agents, iters, lb, ub, dim, @stopFunction};

best_pos = GrasshopperAlgorithm(params, @fitness);
fitness(best_pos)

function [stop] = stopFunction(bestIndividual, iter)
    if iter < 1000
        stop = 0;
    else
        stop = 1;
    end
end