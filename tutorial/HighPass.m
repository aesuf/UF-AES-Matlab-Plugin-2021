classdef HighPass < audioPlugin
  
  properties    
    % public interface
    Cutoff = 30
  end
  
  properties (Constant, Hidden)
    PluginInterface = audioPluginInterface( ...
      'PluginName','High Pass',...
      audioPluginParameter('Cutoff', ...
        'DisplayName',  'Cutoff Freq', ...
        'Label',  'Hz', ...
        'Mapping', { 'log', 20, 2000}))
  end
  
  properties (Access = private)
    % internal state
    z = zeros(2)
    b = [1, zeros(1,2)]
    a = [1, zeros(1,2)]
  end
  
  methods
      
    function out = process(obj, in)
      [out,obj.z] = filter(obj.b, obj.a, in, obj.z);
    end
    
    function reset(obj)
      % initialize internal state
      obj.z = zeros(2);
      Fs = getSampleRate(obj);
      [obj.b, obj.a] = highPassCoeffs(obj.Cutoff, Fs);
    end
    
    function set.Cutoff(obj, Cutoff)
      obj.Cutoff = Cutoff;
      Fs = getSampleRate(obj);
      [obj.b, obj.a] = highPassCoeffs(Cutoff, Fs); %#ok<*MCSUP>
    end
    
  end
  
end
