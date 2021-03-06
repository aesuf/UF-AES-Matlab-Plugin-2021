classdef Echo < audioPlugin
%Echo Add echo effect to an audio signal.
%
%   ECHO = audiopluginexample.Echo() returns an object ECHO with properties
%   set to their default values.
%
%   Echo methods:
%
%   Y = process(ECHO, X) adds echo effect to the audio input X based on the
%   properties specified in the object ECHO and returns it as output Y.
%   Each column of X is treated as individual input channels.
%
%   Echo properties:
%
%   Delay         - Base delay in seconds
%   Gain          - Amplitude gain 
%   FeedbackLevel - Feedback gain 
%   WetDryMix     - Wet to dry signal ratio
%
%   % Example 1: Simulate Echo in MATLAB.
%   reader = dsp.AudioFileReader('SamplesPerFrame', 1024,...
%     'PlayCount', 1);
%
%   player = audioDeviceWriter('SampleRate', reader.SampleRate);
%
%   echo = audiopluginexample.Echo;
%
%   while ~isDone(reader)
%       x = reader();
%       y = process(echo, x);
%       player(y);
%   end
%   release(reader)
%   release(player)
%
%   % Example 2: Validate and generate a VST plugin
%   validateAudioPlugin audiopluginexample.Echo
%   generateAudioPlugin audiopluginexample.Echo
%
%   % Example 3: Launch a test bench for the echo object
%   echo = audiopluginexample.Echo;
%   audioTestBench(echo);
%
%   See also: audiopluginexample.Chorus, audiopluginexample.Flanger

%   Copyright 2015-2019 The MathWorks, Inc.
%#codegen
    
    properties
        %Delay Base delay (s)
        %   Specify the base delay for echo effect as positive scalar
        %   value in seconds. Base delay value must be in the range between
        %   0 and 1 seconds. The default value of this property is 0.5.
        Delay = 0.5
        
        %Gain Gain of delay branch
        %   Specify the gain value as a positive scalar. This value must be
        %   in the range between 0 and 1. The default value of this
        %   property is 0.5.
        Gain = 0.5
    end
       
    properties 
        %FeedbackLevel Feedback gain
        %   Specify the feedback gain value as a positive scalar. This
        %   value must range from 0 to 0.5. Setting FeedbackLevel to 0
        %   turns off the feedback. The default value of this property is
        %   0.35.
        FeedbackLevel = 0.35
    end
        
    properties
        %WetDryMix Wet/dry mix
        %   Specify the wet/dry mix ratio as a positive scalar. This value
        %   ranges from 0 to 1. For example, for a value of 0.6, the ratio
        %   will be 60% wet to 40% dry signal (Wet - Signal that has effect
        %   in it. Dry - Unaffected signal).  The default value of this
        %   property is 0.5.
        WetDryMix = 0.5
    end
    
    properties (Constant)
        % audioPluginInterface manages the number of input/output channels
        % and uses audioPluginParameter to generate plugin UI parameters.
        PluginInterface = audioPluginInterface(...
            'InputChannels',2,...
            'OutputChannels',2,...
            'PluginName','Echo',...
            'VendorName', '', ...
            'VendorVersion', '3.1.4', ...
            'UniqueId', '4pvz',...
            audioPluginParameter('Delay','DisplayName','Base delay','Label','s',...
            'Mapping',{'lin',0 1},'Style','rotaryknob','Layout',[3 1]),...
            audioPluginParameter('Gain','DisplayName','Gain',...
            'Mapping',{'lin',0 1},'Style','vslider','Layout',[1 1]),...
            audioPluginParameter('FeedbackLevel','DisplayName','Feedback',...
            'Mapping',{'lin', 0 0.5},'Style','vslider','Layout',[1 2]),...
            audioPluginParameter('WetDryMix','DisplayName','Wet/dry mix',...
            'Mapping',{'lin',0 1},'Style','rotaryknob','Layout',[3 2]), ...
            audioPluginGridLayout('RowHeight', [200 20 100 20], ...
            'ColumnWidth', [100 100], 'Padding', [10 10 10 30]), ...
            'BackgroundImage', audiopluginexample.private.mwatlogo);
    end
    
    properties (Access = private)        
        %pFractionalDelay DelayFilter object for fractional delay with
        %linear interpolation
        pFractionalDelay
        
        %pSR Sample rate
        pSR
    end
    
    methods
        function obj = Echo()
            fs = getSampleRate(obj);
            obj.pFractionalDelay = audioexample.DelayFilter( ...
                'FeedbackLevel', 0.35, ...
                'SampleRate', fs);
            obj.pSR = fs;
        end
        
        function set.FeedbackLevel(obj, val)
            obj.pFractionalDelay.FeedbackLevel = val;%#ok<MCSUP>
        end
        function val = get.FeedbackLevel(obj)
            val = obj.pFractionalDelay.FeedbackLevel;
        end
        
        function reset(obj)
            % Reset sample rate
            fs = getSampleRate(obj);
            obj.pSR = fs;
            
            % Reset delay
            obj.pFractionalDelay.SampleRate = fs;
            reset(obj.pFractionalDelay);
        end
        
        function y = process(obj, x)
            delayInSamples = obj.Delay*obj.pSR;
            
            % Delay the input
            xd = obj.pFractionalDelay(delayInSamples, x);
            
            % Calculate output by adding wet and dry signal in appropriate
            % ratio
            mix = obj.WetDryMix;
            y = (1-mix)*x + (mix)*(obj.Gain.*xd);
        end

    end
end