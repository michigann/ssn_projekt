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
          obj.currentTrainX = x;
          obj.currentTrainT = t;
          best = StartAlgorithm(obj.trainFcn, @obj.fitness);
          setWeightsFromIndividual(obj, best);
          out = obj;
      end
  end
  
  methods (Access=private) %custom private functions
      function ft = fitness(obj, xn, N, pd)
          for i=1:N
              individual = xn(i,:);
              
              setWeightsFromIndividual(obj, individual);
              out = obj.net_handle(obj.currentTrainX);
              
              ft = [ft perform(obj, obj.currentTrainT, out)];
          end
      end
      
      function setWeightsFromIndividual(obj, individual)
          weights = DataConversionUtils.weightsFromIndividual(obj, individual);
          obj.IW = weights.IW;
          obj.LW = weights.LW;
          obj.b = weights.b;
      end
  end
   
   methods %getters and setters (feedforwardnet wrappers) 
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
   end
   
   methods %neural network functions wrapers
      function view(obj)
          view(obj.net_handle);
      end
      
      function [perf] = perform(obj, t, y)
          perf = mse(obj.net_handle, t, y);
      end
   end
   
   
     methods (Access = protected)
    function propgrp = getPropertyGroups(obj)
        if ~isscalar(obj)
            propgrp = getPropertyGroups@matlab.mixin.CustomDisplay(obj, 'dupa');
        else
            propList = struct('name',obj.name,...
            'userdata',obj.userdata);
            propgrp = matlab.mixin.util.PropertyGroup(propList);
        end
    end
  end
   
end
