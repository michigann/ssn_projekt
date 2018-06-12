clear all 
clc

agents=20; % Number of search agents
dim = 5;
lb = -1;
ub = 1;
iters=1000; % Maximum numbef of iterations
params = {agents, iters, lb, ub, dim};

best_pos = GrasshopperAlgorithm(params, @fitness);
