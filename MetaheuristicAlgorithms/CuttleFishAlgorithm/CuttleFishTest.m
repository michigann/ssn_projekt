clear all 
clc

agents=20; % Number of search agents
dim = 10;
lb = -100;
ub = 100;
iters=1000; % Maximum numbef of iterations
params = {agents, iters, lb, ub, dim};

best_pos = CuttleFishAlgorithm(params, @rastriginsfcn);
rastriginsfcn(best_pos)
