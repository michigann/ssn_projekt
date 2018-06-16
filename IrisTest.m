clear;
clc;

metaInit;

load iris_dataset.mat;

firstClassCode = [0;0];
secondClassCode = [0;1];
thirdClassCode = [1;1];

targets = zeros(2, length(irisTargets));
for i=1:length(irisTargets)
    if irisTargets(1, i) == 1
        targets(:, i) = firstClassCode;
    elseif irisTargets(2, i) == 1
        targets(:, i) = secondClassCode;
    elseif irisTargets(3, i) == 1
        targets(:, i) = thirdClassCode;
    end
end

% Run network
net = metaheuristicnet(5, 'cuttlefish');
net.trainParam.epochs = 10;
net = net.train(irisInputs, targets);

[X, T] = net.getTrainSet();
[testing, expected] = net.getTestSet();

% Check results
result_u = round(net.sim(X));
result = round(net.sim(testing));

trainingAmount = length(X);
trainingCorrect = PerformanceUtils.getDifferences(result_u, T);

testingAmount = length(testing);
testingCorrect = PerformanceUtils.getDifferences(result, expected);

mse_u = net.perform(T, result_u)
mse_t = net.perform(expected, result)

trainingMismatchNumber = trainingAmount - trainingCorrect
trainingMismatchPercentage = (trainingMismatchNumber / trainingAmount) * 100

testingMismatchNumber = testingAmount - testingCorrect
testingMismatchPercentage = (testingMismatchNumber / testingAmount) * 100

