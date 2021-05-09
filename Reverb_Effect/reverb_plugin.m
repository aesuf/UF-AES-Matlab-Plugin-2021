classdef reverb_plugin < audioPlugin
% reverb plugin object

  properties
    bypass = 1
    mix = 1
    %IR = audioread('impulse_responses/Hall.aif');
    IR = audioread('impulse_responses/1st_baptist_nashville_balcony.wav');
  end
  
  properties (Constant, Hidden)
    PluginInterface = audioPluginInterface( ...
      audioPluginParameter( ...
      'bypass','Mapping',{'int', 0, 1}), ...
      audioPluginParameter( ...
      'mix','Mapping',{'lin', 0, 1}), ...
      'PluginName', 'Convolution Reverb');

  end
  
  methods
    
      function out = process(plugin, in)
            in_L_freq = fft(in(:,1));
            in_R_freq = fft(in(:,2));
            ir_L_freq = fft(plugin.IR(:,1));
            ir_R_freq = fft(plugin.IR(:,2));
            
            if length(in_L_freq) > length(ir_L_freq)
                %zero pad ir_L_freq+ir_R_freq
                L1 = length(in_L_freq);
                L2 = length(ir_L_freq);
                ir_L_freq = [ir_L_freq; zeros(L1-L2,1)];
                ir_R_freq = [ir_R_freq; zeros(L1-L2,1)];
            elseif length(ir_L_freq) > length(in_L_freq)
                %zero pad in_L_freq+in_R_freq
                L1 = length(ir_L_freq);
                L2 = length(in_L_freq);
                in_L_freq = [in_L_freq; zeros(L1-L2,1)];
                in_R_freq = [in_R_freq; zeros(L1-L2,1)];
            end
            
            out_L = ifft(in_L_freq.*ir_L_freq);
            out_R = ifft(in_R_freq.*ir_R_freq);
            
        dry = in;
        wet = [out_L(1:length(dry)), out_R(1:length(dry))];
        if plugin.bypass
            wet = in;
        end

        out(:,1) = (1-plugin.mix)*dry(:,1) + (plugin.mix)*wet(:,1);
        out(:,2) = (1-plugin.mix)*dry(:,2) + (plugin.mix)*wet(:,2);
      end
  end
  
end
