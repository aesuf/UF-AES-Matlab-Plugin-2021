[in,fs] = audioread('guitar_sample.mp3');
impulse = audioread('impulse_responses/ir_row_1l_sl_centre.wav');
in = in(1:fs*8,1:2); %only use first 8 seconds of sample
sound(in,fs)
pause

bypass = 0;
mix = 1;
out = real(double(reverb_effect(in, impulse, bypass, mix )));
soundsc(out,fs)
out = out/max(abs(out(:))); %normalize for audiowrite so no clipping
audiowrite("reverb_out_time_domain.wav", out, fs)
