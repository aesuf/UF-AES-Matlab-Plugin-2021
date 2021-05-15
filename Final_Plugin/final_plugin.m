classdef final_plugin < audioPlugin
% delay plugin object

  properties
    bypass = 'Off'
    mix = 1
    %saturation
    sat_type = 'cubic'
    in_gain = 1
    dist_gain = 1
    threshold = 1
    %delay
    del_type = 'basic'
    L_Gain = 1
    R_Gain = 1
    L_Delay = 0
    R_Delay = 0
    L_Feedback = 0
    R_Feedback = 0
  end
  
  properties (Hidden)
    L_prev_buff_size = 0;
    R_prev_buff_size = 0;
    L_delay_buff = 0;
    L_feedback_buff = 0;
    R_delay_buff = 0;
    R_feedback_buff = 0;
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
    audioPluginParameter('sat_type', ...
        'Mapping',{'enum', 'cubic', 'arctan', 'tanh','hard'}, ...
        'DisplayName', 'Saturation Type', ...
        'Layout',[1,3]), ...
    audioPluginParameter('del_type', ...
        'Mapping',{'enum', 'basic', 'ping-pong'}, ...
        'DisplayName', 'Delay Type', ...
        'Layout',[1,4]), ...
    audioPluginParameter( ... %***SATURATION PARAMETERS***
        'in_gain','Mapping',{'pow', 1/3, -10, 6}, ...
        'DisplayName', 'Saturation Input Gain (dB)', ...
        'Style','rotary', ...
        'Layout',[3,1]), ...
    audioPluginParameter( ...
        'dist_gain','Mapping',{'pow', 1/3, -10, 6}, ...
        'DisplayName', 'Saturation Distortion Gain (dB)', ...
        'Style','rotary', ...
        'Layout',[3,2]), ...
    audioPluginParameter( ...
        'threshold','Mapping',{'lin', 0, 1}, ...
        'DisplayName', 'Saturation Clip Threshold(hard)', ...
        'Style','rotary', ...
        'Layout',[3,3]), ...        
    audioPluginParameter( ... %***DELAY PARAMETERS***
        'L_Gain','Mapping',{'pow', 1/3, -10, 6}, ...
        'DisplayName', 'L Delay Gain (dB)', ...
        'Style','rotary', ...
        'Layout',[5,1]), ...
    audioPluginParameter( ...
        'R_Gain','Mapping',{'pow', 1/3, -10, 6}, ...
        'DisplayName', 'R Delay Gain (dB)', ...
        'Style','rotary', ...
        'Layout',[5,2]), ...
    audioPluginParameter( ...
        'L_Delay','Mapping',{'int', 0, 500}, ...
        'DisplayName', 'L Delay (ms)', ...
        'Style','hslider', ...
        'Layout',[5,3]), ...
    audioPluginParameter( ...
        'R_Delay','Mapping',{'int', 0, 500}, ...
        'DisplayName', 'R Delay (ms)', ...
        'Style','hslider', ...
        'Layout',[5,4]), ...
     audioPluginParameter( ...
        'L_Feedback','Mapping',{'lin', 0, 1}, ...
        'DisplayName', 'L Feedback Gain', ...
        'Style','rotary', ...
        'Layout',[5,5]), ...
     audioPluginParameter( ...
        'R_Feedback','Mapping',{'lin', 0, 1}, ...
        'DisplayName', 'R Feedback Gain', ...
        'Style','rotary', ...
        'Layout',[5,6]), ...
    'PluginName', 'Final Effect', ...
    audioPluginGridLayout( ...
        'RowHeight',[100,15,100,15,100,15,100,15,100], ...
        'ColumnWidth',[125,125,125,125,125,125], ...
        'RowSpacing',10));

  end
  
  methods    
    function out = process(plugin, in)
        fs = getSampleRate(plugin);
        dry = in; %use input to get wet/dry data for mixing
        wet = in;
        
        if(strcmp(plugin.bypass,'On'))
            out = dry;
            return
        end

        %Perform Saturation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        adj_in_gain = 10^(plugin.in_gain/10);
        adj_dist_gain = 10^(plugin.dist_gain/10);
        
        %apply effects to wet data
        switch plugin.sat_type
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
               
        %Perform Delay %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        left_in = wet(:,1);
        right_in = wet(:,2);
        left_out = wet(:,1);
        right_out = wet(:,2);

        L_Delay_Samp = floor(fs*plugin.L_Delay/1000); %Convert to Samples from ms
        R_Delay_Samp = floor(fs*plugin.R_Delay/1000);
        
        if(plugin.L_prev_buff_size ~= L_Delay_Samp)
            plugin.L_delay_buff = zeros(L_Delay_Samp,1); %initialize delay buffers with 0's
            plugin.L_feedback_buff = zeros(L_Delay_Samp,1);
        end
        if(plugin.R_prev_buff_size ~= R_Delay_Samp)
            plugin.R_delay_buff = zeros(R_Delay_Samp,1); %initialize delay buffers with 0's
            plugin.R_feedback_buff = zeros(R_Delay_Samp,1);
        end
        plugin.L_prev_buff_size = L_Delay_Samp;
        plugin.R_prev_buff_size = R_Delay_Samp;
        
        if L_Delay_Samp == 0
            plugin.L_delay_buff = 0;
            plugin.L_feedback_buff = 0;
        end
        if R_Delay_Samp == 0
            plugin.R_delay_buff = 0;
            plugin.R_feedback_buff = 0;
        end

        switch plugin.del_type
            case "basic"
                %Basic delay implementation
                for i = 1:length(left_in)
                    if L_Delay_Samp == 0
                        left_out(i) = left_in(i);
                    else
                        %Apply delay and update buffers for LEFT
                        left_out(i) = left_in(i) + 10^(plugin.L_Gain/10)*plugin.L_delay_buff(L_Delay_Samp) + plugin.L_Feedback*plugin.L_feedback_buff(L_Delay_Samp);
                        plugin.L_delay_buff = [left_in(i); plugin.L_delay_buff(1:L_Delay_Samp-1)];
                        plugin.L_feedback_buff = [left_out(i); plugin.L_feedback_buff(1:L_Delay_Samp-1)];
                    end
                    if R_Delay_Samp == 0
                        right_out(i) = right_in(i);
                    else
                        %Apply delay and update buffers for RIGHT
                        right_out(i) = right_in(i) + 10^(plugin.R_Gain/10)*plugin.R_delay_buff(R_Delay_Samp) + plugin.R_Feedback*plugin.R_feedback_buff(R_Delay_Samp);
                        plugin.R_delay_buff = [right_in(i); plugin.R_delay_buff(1:R_Delay_Samp-1)];
                        plugin.R_feedback_buff = [right_out(i); plugin.R_feedback_buff(1:R_Delay_Samp-1)];
                    end
                end
            case "ping-pong"
                %Ping-Pong delay
                 for i = 1:length(left_in)
                    % apply delay
                    if L_Delay_Samp == 0
                        left_out(i) = left_in(i);
                    else
                        left_out(i) = left_in(i) + 10^(plugin.L_Gain/10)*plugin.L_delay_buff(L_Delay_Samp) + plugin.L_Feedback*plugin.L_feedback_buff(L_Delay_Samp);
                        %update delay buffers
                        plugin.L_delay_buff = [left_in(i); plugin.L_delay_buff(1:L_Delay_Samp-1)];
                        %feed left output to right feedback buffer and vice versa
                        plugin.L_feedback_buff = [right_out(i); plugin.L_feedback_buff(1:L_Delay_Samp-1)];
                    end
                    if R_Delay_Samp == 0
                        right_out(i) = right_in(i);
                    else                        
                        right_out(i) = right_in(i) + 10^(plugin.R_Gain/10)*plugin.R_delay_buff(R_Delay_Samp) + plugin.R_Feedback*plugin.R_feedback_buff(R_Delay_Samp);                            
                        %update delay buffers
                        plugin.R_delay_buff = [right_in(i); plugin.R_delay_buff(1:R_Delay_Samp-1)];                                     
                        %feed left output to right feedback buffer and vice versa
                        plugin.R_feedback_buff = [left_out(i); plugin.R_feedback_buff(1:R_Delay_Samp-1)];
                    end
                 end
        end

        wet = [left_out,right_out];
        out = (1-plugin.mix)*dry + (plugin.mix)*wet;
    end
  end
end