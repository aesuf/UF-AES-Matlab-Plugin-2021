%% Introduction to Live Streaming in MATLAB

% Copyright 2018-2019 The MathWorks, Inc.

%% Load finite segment of (stereo) audio 
filename = 'FunkyDrums-44p1-stereo-25secs.mp3';
ainfo = audioinfo(filename);
fs = ainfo.SampleRate;
x = audioread(filename, [1 5*fs]);

%% Offline Audio Processing in MATLAB

% Call processing function
xw = stereoWidth(x, 2);

% Plot modified signal
plot(xw)
% Play modified signal
soundsc(xw, fs)

%% Take a look at equivalent VST plugin in REAPER

%% Live audio processing in MATLAB
% (Can open Spectrum Analyzer from App )
audioTestBench stereoWidthExpander

%% Audio streaming basics

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

% Filter parameters
widthGain = 3;

tic
while isVisible(spect)
    % Read from file
    x = inReader();

    % Filter input block
    y = stereoWidth(x, widthGain);
    
    % Write to audio device
    outWriter(y);
    
    % Visualize spectrum
    spect([x(:,1),y(:,1)])
end

release(inReader), release(outWriter), release(spect)
