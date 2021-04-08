%% Testing Source Code and Generated Plugins for Accuracy and Performance

% Copyright 2018-2019 The MathWorks, Inc.

%% Import ERA-N in MATLAB to use as an object
% Refer to https://accusonus.com/products/era-n to purchase or evaluate
% the plugin ERA-N from Accusonus, used in the following example

% Load the external plugin by providing the name of its main binary library
% (.dll on Windows, .vst on MacOSX)
deNoise = loadAudioPlugin('ERA-N.dll')

% Once imported, the plugin can be used programmatically as if it was a
% MATLAB object, e.g.:
% deNoise.Processing = 60;
% 
% x = randn(512,2);
% 
% y = process(deNoise, x);

%% Interactive de-noising example, in MATLAB
% Initialize a file reader to produce an input signal
inReader = dsp.AudioFileReader('Counting-16-44p1-mono-15secs.wav',...
    'SamplesPerFrame',512,'PlayCount',inf);
outWriter = audioDeviceWriter('SampleRate', inReader.SampleRate);
tscope = dsp.TimeScope('SampleRate',inReader.SampleRate,'TimeSpan',0.200,...
    'YLimits',[-0.5,0.5]);
show(tscope)

deNoise = loadAudioPlugin('ERA-N.dll');

% Add interactive tunability via UI
ui = tuneSingleParameterWithUI(deNoise, 'Processing', 0, 100);
pause(2)

while ishandle(ui)
    % Read from file
    x = inReader();

    % Filter input block
    x2 = [x, x];
    y1 = process(deNoise, x2);

    % Write to audio device
    outWriter(y1);
    
    % Plot in scope
    tscope(y1)
    
    drawnow
end

release(inReader), release(outWriter)

clear tscope

%% Testing generated plugins against original MATLAB code

% Initialize a file reader to produce an input signal
inReader = dsp.AudioFileReader('FunkyDrums-44p1-stereo-25secs.mp3',...
    'SamplesPerFrame',512,'PlayCount',inf);
fs = inReader.SampleRate;
% Initialize a spectrum analyzer to visualize the results over frequency
spect = dsp.SpectrumAnalyzer('SampleRate',fs,...
    'PlotAsTwoSidedSpectrum',false,'FrequencyScale','Log');
show(spect)

% Create a stereo expander
ExpaOrig = stereoWidthExpander();
ExpaVST = loadAudioPlugin('stereoWidthExpander.dll');

% Add interactive tunability via UI
ui = tuneSingleParameterWithUI(ExpaOrig, 'Width', 0, 4);
pause(2)

while ishandle(ui)
    % Read from file
    x = inReader();

    % Filter input block
    ExpaVST.Width = ExpaOrig.Width;
    y1 = process(ExpaOrig, x);
    y2 = process(ExpaVST, x);

    % Visualize spectrum
    spect([y1(:,1), 1.1*y2(:,1)])
    drawnow
end

release(inReader)

%% Try using VST within audioTestBench
audioTestBench
% audioTestBench('stereoWidthExpander.dll')

%% Timing execution of plugins over time
% Refer to example "Measure Performance of Streaming Real-Time Audio Algorithms"

audioIn = dsp.AudioFileReader('FunkyDrums-44p1-stereo-25secs.mp3',...
    'SamplesPerFrame',1024);
audioOut = audioDeviceWriter();

% fastConv = dsp.FrequencyDomainFIRFilter('Numerator',h',...
%     'PartitionForReducedLatency', true,'PartitionLength', 1 * 1024);
fastConv = audiopluginexample.FastConvolver;
fastConvVST = loadAudioPlugin('FastConvolver.dll');

numFrames = 500;
at = audioexample.AudioLoopTimer(numFrames, audioIn.SamplesPerFrame, audioIn.SampleRate);

for k = 1 : numFrames
    x = audioIn();
    
    at.ticLoop
    y = 0.2 * fastConv(x(:,1));
%     y = 0.2 * process(fastConvVST, x(:,1));
    at.tocLoop

    ur = audioOut(y);
end

at.generateReport();
