close all
%[in,fs] = audioread('guitar_sample.mp3');
%in = in(1:fs*8,1:2); %only use first 8 seconds of sample
T = [0:1/fs:1-1/fs];
f = 4;
in = zeros(2,fs);
in(1,:) = sin(2*pi*f*T);
in(2,:) = sin(2*pi*f*T);
in = in.';
%sound(in,fs)
plot(in(:,1))
title("Input waveform")
pause

%set saturation parameters
bypass = 0;
mix = 1;
in_gain = 1;
dist_gain = 1;
type = "cubic";

out = saturation_function(in, bypass, mix, type, in_gain, dist_gain);
plot(out(:,1))
title("Output of saturation")
sound(out,fs)