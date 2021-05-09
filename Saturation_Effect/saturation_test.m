close all
[in,fs] = audioread('guitar_sample.mp3');
in = in(1:fs*8,1:2); %only use first 8 seconds of sample
T = [0:1/fs:1-1/fs];
f = 4;
in = zeros(2,fs);
in(1,:) = sin(2*pi*f*T);
in(2,:) = sin(2*pi*f*T);
in = in.';
%sound(in,fs)
%plot(in(:,1))
%title("Input waveform")
%pause

%% cubic saturation
bypass = 0;
mix = 1;
in_gain = 1;
type = "cubic";

out_1 = saturation_function(in, bypass, mix, type, in_gain, 0);
out_2 = saturation_function(in, bypass, mix, type, in_gain, 0.33);
out_3 = saturation_function(in, bypass, mix, type, in_gain, 0.66);
out_4 = saturation_function(in, bypass, mix, type, in_gain, 1);

figure(1);
subplot(3, 2, 1)
plot(in(:,1))
title("Input waveform")

subplot(3,2,3)
plot(out_1(:,1))
title("dist gain = 0")

subplot(3,2,4)
plot(out_2(:,1))
title("dist gain = 0.33")

subplot(3,2,5)
plot(out_3(:,1))
title("dist gain = 0.66")

subplot(3,2,6)
plot(out_4(:,1))
title("dist gain = 1")

%% arctan saturation
bypass = 0;
mix = 1;
in_gain = 1;
type = "arctan";

out_1 = saturation_function(in, bypass, mix, type, in_gain, 0);
out_2 = saturation_function(in, bypass, mix, type, in_gain, 1);
out_3 = saturation_function(in, bypass, mix, type, in_gain, 5);
out_4 = saturation_function(in, bypass, mix, type, in_gain, 10);

figure(2);
subplot(3, 2, 1)
plot(in(:,1))
title("Input waveform")

subplot(3,2,3)
plot(out_1(:,1))
title("dist gain = 0")

subplot(3,2,4)
plot(out_2(:,1))
title("dist gain = 1")

subplot(3,2,5)
plot(out_3(:,1))
title("dist gain = 5")

subplot(3,2,6)
plot(out_4(:,1))
title("dist gain = 10")

%% tanh saturation
bypass = 0;
mix = 1;
in_gain = 1;
type = "tanh";

out_1 = saturation_function(in, bypass, mix, type, in_gain, 0);
out_2 = saturation_function(in, bypass, mix, type, in_gain, 1);
out_3 = saturation_function(in, bypass, mix, type, in_gain, 5);
out_4 = saturation_function(in, bypass, mix, type, in_gain, 10);

figure(3);
subplot(3, 2, 1)
plot(in(:,1))
title("Input waveform")

subplot(3,2,3)
plot(out_1(:,1))
title("dist gain = 0")

subplot(3,2,4)
plot(out_2(:,1))
title("dist gain = 1")

subplot(3,2,5)
plot(out_3(:,1))
title("dist gain = 5")

subplot(3,2,6)
plot(out_4(:,1))
title("dist gain = 10")

%% sinh saturation
%This one might be wrong
bypass = 0;
mix = 1;
in_gain = 1;
type = "sinh";

out_1 = saturation_function(in, bypass, mix, type, in_gain, 0);
out_2 = saturation_function(in, bypass, mix, type, in_gain, 1);
out_3 = saturation_function(in, bypass, mix, type, in_gain, 5);
out_4 = saturation_function(in, bypass, mix, type, in_gain, 10);

figure(4);
subplot(3, 2, 1)
plot(in(:,1))
title("Input waveform")

subplot(3,2,3)
plot(out_1(:,1))
title("dist gain = 0")

subplot(3,2,4)
plot(out_2(:,1))
title("dist gain = 1")

subplot(3,2,5)
plot(out_3(:,1))
title("dist gain = 5")

subplot(3,2,6)
plot(out_4(:,1))
title("dist gain = 10")