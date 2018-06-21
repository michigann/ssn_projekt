clear;

MetaInit;

neurons = { 2 4 6 8 10 12 14 18 20 [2 2] [4 2] [6 2] [8 2] [10 2] [12 2] [14 2] [18 2] [20 2]};
datasets = { 'votes', 'ovariancancer', 'glass', 'yeast', 'parkinson' };


datasets = {'phishing'};
neurons = { 20 30 40 };


datasets = {'phishing'};
neurons = {[10]};

for i=1:length(datasets)
    dataset = datasets{i};
    
    dataset
    
    for j=1:length(neurons)
       n = neurons{j};
       
       [X, T] = DatasetLoader(dataset);
       
       test_wrong = 0;
       test_all = 0;
       train_wrong = 0;
       train_all = 0;
       
       for k=1:1
           net = feedforwardnet(n);
           net.trainParam.showWindow = 1;
           net.trainParam.epochs = 200;
           net.divideParam.trainRatio = 0.7;
           net.divideParam.testRatio = 0.15;
           net.divideParam.valRatio = 0.15;
           
           [net, tr] = train(net, X, T);
          
           x_train = X(:, tr.trainInd);
           t_train = T(:, tr.trainInd);
           r_train = net(x_train);
           mse_u = perform(net, r_train, t_train);
           
           r_train = DataConversionUtils.convertNetworkResultToClass(r_train);
           train_wrong = train_wrong + PerformanceUtils.getDifferences(r_train, t_train);
           train_all = train_all + length(t_train);
           
           
           x_test = X(:, tr.testInd);
           t_test = T(:, tr.testInd);
           r_test = net(x_test);
           mse_t = perform(net, r_test, t_test);
           
           r_test = DataConversionUtils.convertNetworkResultToClass(r_test);
           
           test_wrong = test_wrong + PerformanceUtils.getDifferences(r_test, t_test);
           test_all = test_all + length(t_test);
           
       end
       
       test_perf = test_wrong / test_all;
       train_perf = train_wrong / train_all;
       
       n
       test_perf
       train_perf
       mse_u
       mse_t
       

    end
end