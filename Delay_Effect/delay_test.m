[in,fs] = audioread('guitar_sample.mp3');
in = in(1:fs*8,1:2); %only use first 8 seconds of sample
sound(in,fs)

%set delay parameters
bypass = 0;
mix = 1;
L_Gain = 0.5;
R_Gain = 0.5;
L_Delay = 200;
R_Delay = 200;
L_Feedback = 0.5;
R_Feedback = 0.5;
type = "basic";

out = delay_function(in,type, bypass, mix, L_Gain,R_Gain,L_Delay,R_Delay,L_Feedback,R_Feedback,fs);
pause
sound(out,fs)