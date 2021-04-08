function [out,state] = highPassFilter(Cutoff, Fs, in, state)
% Note: this function is inefficient in that it calculates new coefficients
% every time it is called regardless of whether Cutoff/Q have changed
[Num,Den] = computeCoefficients(Cutoff, Fs);
[out, state] = filter(Num,Den, in, state);


function [Num,Den] = computeCoefficients(Cutoff, Fs)
% Function to compute filter coefficients
w0 = 2*pi*Cutoff/Fs;
alpha = sin(w0)/sqrt(2);
cosw0 = cos(w0);
norm = 1/(1+alpha);
Num = (1 + cosw0)*norm * [.5 -1 .5];
Den = [1 -2*cosw0*norm (1 - alpha)*norm];