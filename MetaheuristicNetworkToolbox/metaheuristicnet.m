classdef metaheuristicnet < handle
    
  properties
      trainFcn;
      trainParam;
      divideParam;
      performFcn;
  end
   
  properties (Access = private)
      net_handle;
      
      tr;
      currentTrainX;
      currentTrainT;
      
      trainPerformance;
      testPerformance;
  end
  
  properties (Dependent) %feedforwardnet prop. wrappers
      %Neural Network
      name;
      userdata;     
      
      %dimensions
      numInputs;
      numLayers;
     
      %weights
      LW;
      IW;
      b;
  end
  
  methods %custom functions
      
      function net = metaheuristicnet(hiddenSizes, trainFcn)
         net.net_handle = feedforwardnet(hiddenSizes);
         net.trainFcn = trainFcn;
         net.name = 'Metaheuristic Neural Network';
         net.performFcn = 'mse';
         net.trainParam.epochs = 100;
         net.trainParam.goal = 0;
         net.trainParam.show = 1;
         net.divideParam.trainRatio = 0.8;
         net.divideParam.testRatio = 0.2;
      end  
     
      function out = train(obj, x, t)
          fprintf('\n%s training\n', obj.name);
          
          obj = configure(obj, x, t);
          obj.currentTrainX = x;
          obj.currentTrainT = t;
          
          obj.net_handle.divideParam.valRatio = 0;
          obj.net_handle.divideParam.testRatio = obj.divideParam.testRatio;
          obj.net_handle.divideParam.trainRatio = obj.divideParam.trainRatio;
          
          obj.net_handle.trainParam.epochs = 0;
          obj.net_handle.trainParam.showWindow = 0;
          
          [~, trr] = train(obj.net_handle, x, t);
          obj.tr = trr;
          
          obj.trainPerformance = zeros(1, obj.trainParam.epochs);
          obj.testPerformance = zeros(1, obj.trainParam.epochs);
          
          individual = DataConversionUtils.individualFromWeights(obj);
          best = StartAlgorithm(obj.trainFcn, individual, @obj.fitness, obj.trainParam.epochs, @obj.stopCondition);
          obj = setWeightsFromIndividual(obj, best);
          out = obj;
      end
      
      function [x, t] = getTrainSet(obj)
          x = obj.currentTrainX(:, obj.tr.trainInd);
          t = obj.currentTrainT(:, obj.tr.trainInd);
      end
      
      function [x, t] = getTestSet(obj)
          x = obj.currentTrainX(:, obj.tr.testInd);
          t = obj.currentTrainT(:, obj.tr.testInd);
      end
          
  end
  
  methods (Access=private) %custom private functions
      
      function ft = fitness(obj, xn)
          ft = [];
          N = size(xn);
          N = N(1);
          
          for i=1:N
              individual = xn(i,:);
              obj = setWeightsFromIndividual(obj, individual);
              out = sim(obj, obj.currentTrainX);
              ft = [ft perform(obj, obj.currentTrainT, out)];
          end
      end
      
      function stop = stopCondition(obj, bestIndividual, iter)
          obj = setWeightsFromIndividual(obj, bestIndividual);
          
          [x, t] = obj.getTrainSet();
          out = sim(obj, x);
          trainPerf = perform(obj, t, out);
          
          [x, t] = obj.getTestSet();
          out = sim(obj, x);
          testPerf = perform(obj, t, out);  
          
          if obj.trainParam.show
              obj.trainPerformance(iter) = trainPerf;
              obj.testPerformance(iter) = testPerf;
              epochs = 1:iter;
              
              clf;
              hold on;
              trainPerfs = obj.trainPerformance(1:iter);
              plot(epochs, trainPerfs);
              testPerfs = obj.testPerformance(1:iter);
              plot(epochs, testPerfs);
              hold off;
              
              legend('train performance', 'test performance');
              drawnow;
              
              fprintf('\nepoch: %d\ntrain %s: %f\ntest %s: %f\n',...
                  iter, obj.performFcn, testPerf, obj.performFcn, trainPerf);
          end
          
          if (iter >= obj.trainParam.epochs || ...
                  trainPerf <= obj.trainParam.goal)
              stop = 1;
          else
              stop = 0;
          end
      end
      
      function obj = setWeightsFromIndividual(obj, individual)
          weights = DataConversionUtils.weightsFromIndividual(obj, individual);
          
          obj.net_handle.IW = weights.IW;
          obj.net_handle.LW = weights.LW;
          obj.net_handle.b = weights.b;
      end
      
  end
   
   methods %getters and setters (network wrappers) 
       
       function obj = set.name(obj, name)
           obj.net_handle.name = name;
       end
       
       function out = get.name(obj)
           out = obj.net_handle.name;
       end
       
       function obj = set.userdata(obj, userdata)
           obj.net_handle.userdata = userdata;
       end
       
       function out = get.userdata(obj)
           out = obj.net_handle.userdata;
       end
       
       function obj = set.IW(obj, IW)
           obj.net_handle.IW = IW;
       end
       
       function out = get.IW(obj)
           out = obj.net_handle.IW;
       end
       
       function obj = set.LW(obj, LW)
           obj.net_handle.LW = LW;
       end
       
       function out = get.LW(obj)
           out = obj.net_handle.LW;
       end
       
       function obj = set.b(obj, b)
           obj.net_handle.b = b;
       end
       
       function out = get.b(obj)
           out = obj.net_handle.b;
       end
       
   end
   
   methods %neural network functions wrapers
      
      function view(obj)
          view(obj.net_handle);
      end
      
      function [perf] = perform(obj, t, y)
          if obj.performFcn == "mse"
              perf = mse(obj.net_handle, t, y);
          elseif obj.performFcn == "classification"
              res = DataConversionUtils.convertNetworkResultToClass(y);
              perf = PerformanceUtils.getDifferences(res, t)/size(t,2);
          end
      end
      
      function obj = configure(obj, t, y)
          obj.net_handle = configure(obj.net_handle, t, y);
      end
      
      function out = sim(obj,x)
         x = DataConversionUtils.normData(x);
         out = obj.net_handle(x);
      end
      
   end
 
end
