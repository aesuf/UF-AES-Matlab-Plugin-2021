% Butterworth high pass filter coefficients
 
% Copyright 2016 The MathWorks, Inc.

% Example taken from:
% Bristow-Johnson, R., “Cookbook formulae for audio EQ biquad filter
% coefficients,” 2004, http://www.musicdsp.org/files/Audio-EQ-Cookbook.txt

function [b, a] = highPassCoeffs(Fc, Fs)
  w0 = 2*pi*Fc/Fs;
  alpha = sin(w0)/sqrt(2);
  cosw0 = cos(w0);
  norm = 1/(1+alpha);
  b = (1 + cosw0)*norm * [.5  -1  .5];
  a = [1  -2*cosw0*norm  (1 - alpha)*norm];
end
