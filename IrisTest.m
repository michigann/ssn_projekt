clear;
clc;

metaInit;

[inputs, targets] = DatasetLoader('ionosphere');

% Run network
hiddenSizes = 4;
algorithm = 'grasshopper';
net = metaheuristicnet(hiddenSizes, algorithm);
net.trainParam.epochs = 200;

net = net.train(inputs, targets);

[X, T] = net.getTrainSet();
[testing, expected] = net.getTestSet();

% Check results
result_u_exact = net.sim(X);
result_u = PerformanceUtils.convertResult(result_u_exact);

result_exact = net.sim(testing);
result = PerformanceUtils.convertResult(result_exact);

trainingAmount = length(X);
trainingMismatchNumber = PerformanceUtils.getDifferences(result_u, T);

testingAmount = length(testing);
testingMismatchNumber = PerformanceUtils.getDifferences(result, expected);

mse_u = net.perform(T, result_u);
mse_t = net.perform(expected, result);

fprintf('For %s\n', algorithm);
trainingMismatchPercentage = (trainingMismatchNumber / trainingAmount) * 100;
fprintf('mismatch(u) = %d / %f %%, mse(u) = %f\n', trainingMismatchNumber, trainingMismatchPercentage, mse_u);
testingMismatchPercentage = (testingMismatchNumber / testingAmount) * 100;
fprintf('mismatch(t) = %d / %f %%, mse(t) = %f\n', testingMismatchNumber, testingMismatchPercentage, mse_t);

