classdef stereoWidthExpander < audioPlugin
% Stereo width expander example
% 
% Copyright 2016-2019 The MathWorks, Inc.

  properties
    Width = 1
  end
  
  properties (Constant, Hidden)
    PluginInterface = audioPluginInterface( ...
      audioPluginParameter('Width', ...
      'Mapping', {'pow', 2, 0, 4}))
  end
  
  methods
    
      function out = process(plugin, in)
          mid = (in(:,1) + in(:,2)) / 2;
          side = (in(:,1) - in(:,2)) / 2;
          side = side * plugin.Width;
          out = [mid + side   mid - side];
      end
  end
  
end
