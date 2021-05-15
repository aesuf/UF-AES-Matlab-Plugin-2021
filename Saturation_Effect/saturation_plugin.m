classdef saturation_plugin < audioPlugin
% saturation plugin object

  properties
    bypass = 'Off'
    mix = 1
    type = 'cubic'
    in_gain = 1
    dist_gain = 1
    threshold = 1
  end
  
  properties (Constant, Hidden)
    PluginInterface = audioPluginInterface( ...
    audioPluginParameter( ...
        'bypass','Mapping',{'enum', 'On', 'Off'}, ...
        'DisplayName', 'Bypass', ...
        'Layout',[1,1]), ...
    audioPluginParameter( ...
        'mix','Mapping',{'lin', 0, 1}, ...
        'Style','rotary', ...
        'Layout',[1,2]), ...
    audioPluginParameter('type', ...
        'Mapping',{'enum', 'cubic', 'arctan', 'tanh','hard'}, ...
        'Layout',[1,3]), ...
    audioPluginParameter( ...
        'in_gain','Mapping',{'pow', 1/3, -10, 6}, ...
        'DisplayName', 'Input Gain (dB)', ...
        'Style','rotary', ...
        'Layout',[3,1]), ...
    audioPluginParameter( ...
        'dist_gain','Mapping',{'pow', 1/3, -10, 6}, ...
        'DisplayName', 'Distortion Gain (dB)', ...
        'Style','rotary', ...
        'Layout',[3,2]), ...
    audioPluginParameter( ...
        'threshold','Mapping',{'lin', 0, 1}, ...
        'DisplayName', 'Hard Clipping Threshold', ...
        'Style','rotary', ...
        'Layout',[3,3]), ...
    'PluginName', 'Saturation Effect', ...
    audioPluginGridLayout( ...
        'RowHeight',[100,100,150,80,80], ...
        'ColumnWidth',[125,125,100,100], ...
        'RowSpacing',10));

  end
  
  methods    
    function out = process(plugin, in)
        dry = in; %use input to get wet/dry data for mixing
        wet = in; 

        if(strcmp(plugin.bypass,'On'))
            out = dry;
            return
        end
        
        adj_in_gain = 10^(plugin.in_gain/10);
        adj_dist_gain = 10^(plugin.dist_gain/10);
        
        %apply effects to wet data
        switch plugin.type
        case "cubic"
            %Cubic distortion
            wet(:,1) = adj_in_gain*in(:,1) - adj_dist_gain*(1/3)*in(:,1).^3;
            wet(:,2) = adj_in_gain*in(:,2) - adj_dist_gain*(1/3)*in(:,2).^3;
        case "arctan"
            %arctan distortion
            wet(:,1) = (2/pi)*atan(in(:,1).*adj_dist_gain*adj_in_gain); 
            wet(:,2) = (2/pi)*atan(in(:,2).*adj_dist_gain*adj_in_gain);
        case "tanh"
            %tanh distortion
            wet(:,1) = tanh(in(:,1).*adj_dist_gain*adj_in_gain); 
            wet(:,2) = tanh(in(:,2).*adj_dist_gain*adj_in_gain);
        case "hard"
            %hard clipping
            for i= 1:length(wet(:,1))
                %First Channel
                if(in(i,1) > plugin.threshold)
                    wet(i,1) = plugin.threshold;
                elseif(in(i,1) < -plugin.threshold)
                    wet(i,1) = -plugin.threshold;
                else
                    wet(i,1) = in(i,1);
                end
                %Second Channel
                if(in(i,2) > plugin.threshold)
                    wet(i,2) = plugin.threshold;
                elseif(in(i,2) < -plugin.threshold)
                    wet(i,2) = -plugin.threshold;
                else
                    wet(i,2) = in(i,2);
                end
            end    
            wet = wet.*adj_in_gain;
        otherwise
            %Default to cubic distortion
            wet(:,1) = adj_in_gain*in(:,1) - adj_dist_gain*(1/3)*in(:,1).^3;
            wet(:,2) = adj_in_gain*in(:,2) - adj_dist_gain*(1/3)*in(:,2).^3;
        end
        %Mix data into output
        out = (1-plugin.mix)*dry + (plugin.mix)*wet;
    end
  end
end