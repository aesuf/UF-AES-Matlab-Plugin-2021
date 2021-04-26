filename = 'sayitaintso.wav';
ainfo = audioinfo(filename);
fs = ainfo.SampleRate;
x = audioread(filename, [1 10*fs]);

%%
%audioTestBench stereoDelayControl
echo = audiopluginexample.Echo;
audioTestBench(echo);
%%
% Initialize a file reader to produce an input signal
inReader = dsp.AudioFileReader('sayitaintso.wav',...
    'SamplesPerFrame',512,'PlayCount',inf);
fs = inReader.SampleRate;
% Initialize a device writer to play back the output
outWriter = audioDeviceWriter('SampleRate', fs);
% Initialize a spectrum analyzer to visualize the results over frequency
spect = dsp.SpectrumAnalyzer('SampleRate',fs,...
    'PlotAsTwoSidedSpectrum',false,'FrequencyScale','Log');
show(spect)

% Filter parameters
L_Gain = 0.5;
R_Gain = 0.5;
L_Delay = 200;
R_Delay = 200;

tic
while isVisible(spect)
    % Read from file
    x = inReader();

    % Filter input block
    y = stereoDelay(x, L_Gain, R_Gain, L_Delay, R_Delay);
    
    % Write to audio device
    outWriter(y);
    
    % Visualize spectrum
    spect([x(:,1),y(:,1)])
end

release(inReader), release(outWriter), release(spect)