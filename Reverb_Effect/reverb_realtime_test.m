filename = 'guitar_sample.mp3';
ainfo = audioinfo(filename);
fs = ainfo.SampleRate;
x = audioread(filename, [1 10*fs]);

IR = audioread('impulse_responses/Hall.aif');
%%
% Initialize a file reader to produce an input signal
inReader = dsp.AudioFileReader('guitar_sample.mp3',...
    'SamplesPerFrame',512,'PlayCount',inf);
fs = inReader.SampleRate;
% Initialize a device writer to play back the output
outWriter = audioDeviceWriter('SampleRate', fs);
% Initialize a spectrum analyzer to visualize the results over frequency
spect = dsp.SpectrumAnalyzer('SampleRate',fs,...
    'PlotAsTwoSidedSpectrum',false,'FrequencyScale','Log');
show(spect)

rvb = reverb_plugin();

ui = tuneSingleParameterWithUI(rvb, 'mix', 0, 1);
bypass = 0;

while ishandle(ui)
    % Read from file
    x = inReader();

    % Filter input block

    y = process(rvb,x);
    
    % Write to audio device
    outWriter(y);
    
    % Visualize spectrum
    %spect([x(:,1),y(:,1)])
    spect([x(:,1),y(:,1)])
    drawnow
end

release(inReader), release(outWriter), release(spect)

%%
rvb = reverb_plugin();

audioTestBench(rvb);
%%
validateAudioPlugin reverb_plugin