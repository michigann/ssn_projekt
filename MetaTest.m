clear;
clc;

MetaInit;

[inputs, targets] = DatasetLoader('phishing');

% Run network
hiddenSizes = 10;
algorithm = 'crow';
net = metaheuristicnet(hiddenSizes, algorithm);
net.trainParam.epochs = 200;
net.performFcn = 'mse';

net = train(net, inputs, targets);

[X, T] = net.getTrainSet();
[testing, expected] = net.getTestSet();

% Check results
result_u_exact = net.sim(X);
result_u = DataConversionUtils.convertNetworkResultToClass(result_u_exact);

result_exact = net.sim(testing);
result = DataConversionUtils.convertNetworkResultToClass(result_exact);

trainingAmount = size(X,2);
trainingMismatchNumber = PerformanceUtils.getDifferences(result_u, T);

testingAmount = size(testing,2);
testingMismatchNumber = PerformanceUtils.getDifferences(result, expected);

mse_u = net.perform(T, result_u_exact);
mse_t = net.perform(expected, result_exact);

fprintf('For %s\n', algorithm);
trainingMismatchPercentage = (trainingMismatchNumber / trainingAmount) * 100;
fprintf('mismatch(u) = %d / %f %%, mse(u) = %f\n', trainingMismatchNumber, trainingMismatchPercentage, mse_u);
testingMismatchPercentage = (testingMismatchNumber / testingAmount) * 100;
fprintf('mismatch(t) = %d / %f %%, mse(t) = %f\n', testingMismatchNumber, testingMismatchPercentage, mse_t);

