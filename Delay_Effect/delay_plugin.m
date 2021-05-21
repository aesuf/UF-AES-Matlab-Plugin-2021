classdef delay_plugin < audioPlugin
% delay plugin object

  properties
    bypass = 'Off'
    mix = 0.5
    type = 'Stereo'
    L_Gain = 1
    R_Gain = 1
    time_L = '1/4'
    time_R = '1/4'
    L_Feedback = 0.5
    R_Feedback = 0.5 
    Tempo = 100
  end
  
  %-----------------------------------------------------------------------
  % Private Properties - Internal properties
  %-----------------------------------------------------------------------
  properties (Access = private)
      L_delay_ms = 600;
      R_delay_ms = 600;
      Buffer = zeros(192001,2) %Allows up to 4 seconds of delay at 48kHz
      Out_Buffer = zeros(192001,2) 
      L_Index = 1;
      R_Index = 1;
      
  end
  
  %-----------------------------------------------------------------------
  % Constant Properties - Interface properties
  %-----------------------------------------------------------------------
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
        'Mapping',{'enum', 'Stereo', 'ping-pong'}, ...
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
    audioPluginParameter('time_L', ...
        'Mapping',{'enum', '1/16T', '1/16D', '1/16', ...
        '1/8T', '1/8D', '1/8', '1/4T', '1/4D', '1/4', ...
        '1/2T', '1/2D', '1/2', '1/1'}, ...
        'DisplayName', 'Left Delay ', ...
        'Layout',[5,1]), ...
    audioPluginParameter('time_R', ...
        'Mapping',{'enum', '1/16T', '1/16D', '1/16', ...
        '1/8T', '1/8D', '1/8', '1/4T', '1/4D', '1/4', ...
        '1/2T', '1/2D', '1/2', '1/1'}, ...
        'DisplayName', 'Right Delay ', ...
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
        'RowSpacing',10), ...
    audioPluginParameter('Tempo', ...
            'Mapping',{'int',20,999}, ...
            'Layout',[7,3], ...
            'Style','hslider'));

  end
  
  methods    
      
    %-------------------------------------------------------------------
    % Main
    %-------------------------------------------------------------------  
    function out = process(plugin, in)
        fs = getSampleRate(plugin);
        dry = in; %use input to get wet/dry data for mixing

        if(strcmp(plugin.bypass,'On'))
            out = dry;
            return
        end
        switch plugin.time_L
                case "1/16T"
                    plugin.L_delay_ms = (((60000/plugin.Tempo)/4)*(2/3));
                case "1/16D"
                    plugin.L_delay_ms = ((60000/plugin.Tempo)/4)*(1.5);
                case "1/16"  
                    plugin.L_delay_ms = ((60000/plugin.Tempo)/4);
                case "1/8T"
                    plugin.L_delay_ms = ((60000/plugin.Tempo)/2)*(2/3);
                case "1/8D"
                    plugin.L_delay_ms = ((60000/plugin.Tempo)/2)*1.5;
                case "1/8"    
                    plugin.L_delay_ms = ((60000/plugin.Tempo)/2);
                case "1/4T"
                    plugin.L_delay_ms = ((60000/plugin.Tempo)*(2/3));
                case "1/4D"
                    plugin.L_delay_ms = (60000/plugin.Tempo)*(1.5);
                case "1/4"  
                    plugin.L_delay_ms = ((60000/plugin.Tempo));
                case "1/2T"
                    plugin.L_delay_ms = ((60000/plugin.Tempo)*2)*(2/3);
                case "1/2D"
                    plugin.L_delay_ms = ((60000/plugin.Tempo)*2)*1.5;
                case "1/2"    
                    plugin.L_delay_ms = ((60000/plugin.Tempo)*2);
                case "1/1"  
                    plugin.L_delay_ms = (60000/plugin.Tempo)*4;
                otherwise
                    plugin.L_delay_ms = 600;
        end
        
        switch plugin.time_R
                case "1/16T"
                    plugin.R_delay_ms = (((60000/plugin.Tempo)/4)*(2/3));
                case "1/16D"
                    plugin.R_delay_ms = ((60000/plugin.Tempo)/4)*(1.5);
                case "1/16"  
                    plugin.R_delay_ms = ((60000/plugin.Tempo)/4);
                case "1/8T"
                    plugin.R_delay_ms = ((60000/plugin.Tempo)/2)*(2/3);
                case "1/8D"
                    plugin.R_delay_ms = ((60000/plugin.Tempo)/2)*1.5;
                case "1/8"    
                    plugin.R_delay_ms = ((60000/plugin.Tempo)/2);
                case "1/4T"
                    plugin.R_delay_ms = ((60000/plugin.Tempo)*(2/3));
                case "1/4D"
                    plugin.R_delay_ms = (60000/plugin.Tempo)*(1.5);
                case "1/4"  
                    plugin.R_delay_ms = ((60000/plugin.Tempo));
                case "1/2T"
                    plugin.R_delay_ms = ((60000/plugin.Tempo)*2)*(2/3);
                case "1/2D"
                    plugin.R_delay_ms = ((60000/plugin.Tempo)*2)*1.5;
                case "1/2"    
                    plugin.R_delay_ms = ((60000/plugin.Tempo)*2);
                case "1/1"  
                    plugin.R_delay_ms = (60000/plugin.Tempo)*4;
                otherwise
                    plugin.R_delay_ms = 600;
        end
        
        L_Delay_Samp = floor(fs*plugin.L_delay_ms/1000); %Convert to Samples from ms
        R_Delay_Samp = floor(fs*plugin.R_delay_ms/1000);
        out = in; %initialize out to same dimensions as input
        
        switch plugin.type
            case "Stereo"
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