classdef stereoDelayControl < audioPlugin
    
    properties
        L_Gain = 0.5
        R_Gain = 0.5
        L_Delay = 200
        R_Delay = 200
    end
    
    properties (Constant, Hidden)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('L_Gain','Mapping',{'lin', 0, 1}), ...
            audioPluginParameter('R_Gain','Mapping',{'lin', 0, 1}), ...
            audioPluginParameter('L_Delay','Mapping',{'int', 0, 1000}), ...
            audioPluginParameter('R_Delay','Mapping',{'int', 0, 1000}));
    end
    
    methods
        function out = process(plugin, in)
            left = in(:,1);
            right = in(:,2);
            L_delay_buff = zeros(plugin.L_Delay,1);
            R_delay_buff = zeros(plugin.R_Delay,1);
            for i = 1:length(left)
                left(i) = left(i) + plugin.L_Gain*L_delay_buff(plugin.L_Delay);
                L_delay_buff = [left(i); L_delay_buff(1:plugin.L_Delay-1)];
                right(i) = right(i) + plugin.R_Gain*R_delay_buff(plugin.R_Delay);
                R_delay_buff = [right(i); R_delay_buff(1:plugin.R_Delay-1)];
            end
            out = [left right];
        end
    end
end
            