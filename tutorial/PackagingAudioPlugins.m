%% Packaging Algorithms as audioPlugin Modules

% Copyright 2018-2019 The MathWorks, Inc.

%% Packaging algorithms as modules with consistent interface
edit stereoWidthExpander

%% Live-tuning a modular algorithm

% Initialize a file reader to produce an input signal
inReader = dsp.AudioFileReader('FunkyDrums-44p1-stereo-25secs.mp3',...
    'SamplesPerFrame',512,'PlayCount',inf);
fs = inReader.SampleRate;
% Initialize a device writer to play back the output
outWriter = audioDeviceWriter('SampleRate', fs);
% Initialize a spectrum analyzer to visualize the results over frequency
spect = dsp.SpectrumAnalyzer('SampleRate',fs,...
    'PlotAsTwoSidedSpectrum',false,'FrequencyScale','Log');
show(spect)

% Create a stereo expander
Expa = stereoWidthExpander();

% Add interactive tunability via UI
ui = tuneSingleParameterWithUI(Expa, 'Width', 0, 4);
pause(2)

while ishandle(ui)
    % Read from file
    x = inReader();

    % Filter input block
    y = process(Expa, x);

    % Write to audio device
    outWriter(y);

    % Visualize spectrum
    spect([x(:,1),y(:,1)])
    drawnow
end

release(inReader), release(outWriter)

%% Automating streaming and live tuning with Audio Test Bench
% Once the algorithm  encapsulates all the info, everything can be automated

Expa = stereoWidthExpander();

audioTestBench(Expa);

%% Generate a VST plugin automatically
% Equally, because all the information is specified we can also generate a
% VST plugin

generateAudioPlugin stereoWidthExpander

% generateAudioPlugin -outdir C:\MATLAB\VSTPlugins stereoWidthExpander

disp('Done generating VST plugin!')

%% Always better to first test MATLAB code systematically

validateAudioPlugin stereoWidthExpander

%% More interesting advantages of using audioPlugin modules
% * Low-rate internal parameter update
% * Presence of internal states - storing and resetting 
% * Dependency on Host Sample Rate
edit highPassFilter
edit HighPass

%% Use of visualization to debug internal behavior

% 3-band parametric EQ (see doc example)
eq = audiopluginexample.ParametricEqualizerWithUDP;
% Open up dynamic visualization
visualize(eq)
% Tune parameters live
audioTestBench(eq)
