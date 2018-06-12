classdef metaheuristicnet
   properties
      trainFcn;
   end
   
  properties (Access = private)
      net_handle;
      currentTrainX;
      currentTrainT;
  end
  
  properties (Dependent) %feedforwardnet prop wrappers
      %Neural Network
      name;
      userdata;
      trainParam;      
      
      %dimensions
      numInputs;
      numLayers;
      
      LW;
      IW;
      b;
  end
  
  methods %custom functions
      
      function net = metaheuristicnet(hiddenSizes, trainFcn)
         net.net_handle = feedforwardnet(hiddenSizes);
         net.trainFcn = trainFcn;
         net.name = 'Metaheuristic Neural Network';
      end  
     
      function out = train(obj, x, t)
          disp('train to implement');
          obj = configure(obj, x, t);
          obj.currentTrainX = x;
          obj.currentTrainT = t;
          individual = DataConversionUtils.individualFromWeights(obj);
          best = StartAlgorithm(obj.trainFcn, @obj.fitness, @obj.stopCondition, individual);
          obj = setWeightsFromIndividual(obj, best);
          out = obj;
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
              out = obj.net_handle(obj.currentTrainX);
              ft = [ft perform(obj, obj.currentTrainT, out)];
          end
      end
      
      function stop = stopCondition(obj, best, iter)
          obj = setWeightsFromIndividual(obj, best);
          out = obj.net_handle(obj.currentTrainX);
          perform(obj, obj.currentTrainT, out);
          
          iter
          
          if (iter < obj.net_handle.trainParam.epochs)
              stop = 0;
          else
              stop = 1;
          end
      end
      
      function obj = setWeightsFromIndividual(obj, individual)
          weights = DataConversionUtils.weightsFromIndividual(obj, individual);
          
          obj.net_handle.IW = weights.IW;
          obj.net_handle.LW = weights.LW;
          obj.net_handle.b = weights.b;
          %obj.net_handle.LW{2,1}
      end
      
  end
   
   methods %getters and setters (network wrappers) 
       
       function obj = set.name(obj, name)
           obj.net_handle.name = name;
       end
       
       function out = get.name(obj)
           out = obj.net_handle.userdata;
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
       
       function out = get.trainParam(obj)
          out = obj.net_handle.trainParam; 
       end
       
       function obj = set.trainParam(obj, trainParam)
          obj.net_handle.trainParam = trainParam; 
       end
       
   end
   
   methods %neural network functions wrapers
      
       function view(obj)
          view(obj.net_handle);
      end
      
      function [perf] = perform(obj, t, y)
          perf = mse(obj.net_handle, t, y);
      end
      
      function obj = configure(obj, t, y)
          obj.net_handle = configure(obj.net_handle, t, y);
      end
      
      function out = sim(obj,x)
         out = obj.net_handle(x);
      end
      
   end
   
   methods (Access = protected)
       
       function propgrp = getPropertyGroups(obj)
           if ~isscalar(obj)
               propgrp = getPropertyGroups@matlab.mixin.CustomDisplay(obj, 'prop');
           else
               propList = struct('name',obj.name,'userdata',obj.userdata);
               propgrp = matlab.mixin.util.PropertyGroup(propList);
           end
       end
       
   end
   
end
