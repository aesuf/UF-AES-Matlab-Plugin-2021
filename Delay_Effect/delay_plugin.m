classdef delay_plugin < audioPlugin
% delay plugin object

  properties
    bypass = 'Off'
    mix = 1
    type = 'basic'
    L_Gain = 1
    R_Gain = 1
    L_Delay = 200
    R_Delay = 200
    L_Feedback = 0
    R_Feedback = 0
  end
  
  properties (Access = private)
      Buffer = zeros(192001,2) %Allows up to 4 seconds of delay at 48kHz
      Out_Buffer = zeros(192001,2) 
      L_Index = 0;
      R_Index = 0;
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
        'Mapping',{'enum', 'basic', 'ping-pong'}, ...
        'Layout',[1,3]), ...
    audioPluginParameter( ...
        'L_Gain','Mapping',{'pow', 1/3, -10, 6}, ...
        'DisplayName', 'Left Gain (dB)', ...
        'Style','rotary', ...
        'Layout',[3,1]), ...
    audioPluginParameter( ...
        'R_Gain','Mapping',{'pow', 1/3, -10, 6}, ...
        'DisplayName', 'Right Gain (dB)', ...
        'Style','rotary', ...
        'Layout',[3,2]), ...
    audioPluginParameter( ...
        'L_Delay','Mapping',{'int', 0, 4000}, ...
        'DisplayName', 'Left Delay (ms)', ...
        'Style','hslider', ...
        'Layout',[5,1]), ...
    audioPluginParameter( ...
        'R_Delay','Mapping',{'int', 0, 4000}, ...
        'DisplayName', 'Right Delay (ms)', ...
        'Style','hslider', ...
        'Layout',[5,2]), ...
     audioPluginParameter( ...
        'L_Feedback','Mapping',{'lin', 0, 1}, ...
        'DisplayName', 'Feedback (L)', ...
        'Style','rotary', ...
        'Layout',[7,1]), ...
     audioPluginParameter( ...
        'R_Feedback','Mapping',{'lin', 0, 1}, ...
        'DisplayName', 'Feedback (R)', ...
        'Style','rotary', ...
        'Layout',[7,2]), ...
    'PluginName', 'Delay Effect', ...
    audioPluginGridLayout( ...
        'RowHeight',[100,15,100,15,100,15,100,15,100], ...
        'ColumnWidth',[125,125,125,125,125,125], ...
        'RowSpacing',10));

  end
  
  methods    
    function out = process(plugin, in)
        fs = getSampleRate(plugin);
        dry = in; %use input to get wet/dry data for mixing

        if(strcmp(plugin.bypass,'On'))
            out = dry;
            return
        end

        L_Delay_Samp = floor(fs*plugin.L_Delay/1000); %Convert to Samples from ms
        R_Delay_Samp = floor(fs*plugin.R_Delay/1000);
        out = in; %initialize out to same dimensions as input
        
        switch plugin.type
            case "basic"
                %Basic delay implementation, based on https://www.mathworks.com/help/audio/gs/audio-plugins-in-matlab.html
                %Left Channel
                writeIndex = plugin.L_Index;
                readIndex = writeIndex-L_Delay_Samp;
                
                if(readIndex <= 0) %Handle underflow of circular buffer
                    readIndex = readIndex + length(plugin.Buffer);
                end
                
                for i = 1:length(in(:,1))
                    plugin.Buffer(writeIndex,1) = in(i,1);
                    delay = plugin.Buffer(readIndex,1);
                    feedback = plugin.Out_Buffer(readIndex,1);
                    out(i,1) = (1-plugin.mix)*in(i,1) + plugin.mix*(10^(plugin.L_Gain/10)*delay + plugin.L_Feedback*feedback);
                    plugin.Out_Buffer(writeIndex,1) = out(i,1);
                    
                    writeIndex = writeIndex + 1; %Handle overflow of circular buffer
                    if(writeIndex > length(plugin.Buffer))
                        writeIndex = 1;
                    end
                    
                    readIndex = readIndex + 1; %Handle overflow of circular buffer
                    if(readIndex > length(plugin.Buffer))
                        readIndex = 1;
                    end
                end
                plugin.L_Index = writeIndex;
                %Right Channel
                writeIndex = plugin.R_Index;
                readIndex = writeIndex-R_Delay_Samp;
                
                if(readIndex <= 0) %Handle underflow of circular buffer
                    readIndex = readIndex + length(plugin.Buffer);
                end
                
                for i = 1:length(in(:,2))
                    plugin.Buffer(writeIndex,2) = in(i,2);
                    delay = plugin.Buffer(readIndex,2);
                    feedback = plugin.Out_Buffer(readIndex,2);
                    out(i,2) = (1-plugin.mix)*in(i,2) + plugin.mix*(10^(plugin.R_Gain/10)*delay + plugin.R_Feedback*feedback);
                    plugin.Out_Buffer(writeIndex,2) = out(i,2);
                    
                    writeIndex = writeIndex + 1; %Handle overflow of circular buffer
                    if(writeIndex > length(plugin.Buffer))
                        writeIndex = 1;
                    end
                    
                    readIndex = readIndex + 1; %Handle overflow of circular buffer
                    if(readIndex > length(plugin.Buffer))
                        readIndex = 1;
                    end
                end
                plugin.R_Index = writeIndex;
                
            case "ping-pong"
                %Ping-pong delay implementation
                out = in; %initialize out to same dimensions as input
                %Left Channel
                writeIndex = plugin.L_Index;
                readIndex = writeIndex-L_Delay_Samp;

                if(readIndex <= 0) %Handle underflow of circular buffer
                    readIndex = readIndex + length(plugin.Buffer);
                end

                for i = 1:length(in(:,1))
                    plugin.Buffer(writeIndex,1) = in(i,1);
                    delay = plugin.Buffer(readIndex,1);
                    feedback = plugin.Out_Buffer(readIndex,2);
                    out(i,1) = (1-plugin.mix)*in(i,1) + plugin.mix*(10^(plugin.L_Gain/10)*delay + plugin.L_Feedback*feedback);
                    plugin.Out_Buffer(writeIndex,1) = out(i,1);

                    writeIndex = writeIndex + 1; %Handle overflow of circular buffer
                    if(writeIndex > length(plugin.Buffer))
                        writeIndex = 1;
                    end

                    readIndex = readIndex + 1; %Handle overflow of circular buffer
                    if(readIndex > length(plugin.Buffer))
                        readIndex = 1;
                    end
                end
                plugin.L_Index = writeIndex;
                %Right Channel
                writeIndex = plugin.R_Index;
                readIndex = writeIndex-R_Delay_Samp;

                if(readIndex <= 0) %Handle underflow of circular buffer
                    readIndex = readIndex + length(plugin.Buffer);
                end

                for i = 1:length(in(:,2))
                    plugin.Buffer(writeIndex,2) = in(i,2);
                    delay = plugin.Buffer(readIndex,2);
                    feedback = plugin.Out_Buffer(readIndex,1);
                    out(i,2) = (1-plugin.mix)*in(i,2) + plugin.mix*(10^(plugin.R_Gain/10)*delay + plugin.R_Feedback*feedback);
                    plugin.Out_Buffer(writeIndex,2) = out(i,2);

                    writeIndex = writeIndex + 1; %Handle overflow of circular buffer
                    if(writeIndex > length(plugin.Buffer))
                        writeIndex = 1;
                    end

                    readIndex = readIndex + 1; %Handle overflow of circular buffer
                    if(readIndex > length(plugin.Buffer))
                        readIndex = 1;
                    end
                end
                plugin.R_Index = writeIndex;
        end
    end
  end
end