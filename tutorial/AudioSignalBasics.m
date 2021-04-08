%% Basics on Audio Signal Manipulation

% Copyright 2018-2019 The MathWorks, Inc.

%% Load some music samples
filename = 'FunkyDrums-44p1-stereo-25secs.mp3';
[xlong, fs] = audioread(filename);
plot(xlong)

%% Listen to loaded samples
soundsc(xlong, fs)

%% Select first 3 seconds
tmax = 3;
nmax = tmax * fs;
x = xlong(1:nmax, 1:2);

%% Plot and listen
plot(x)
soundsc(x, fs)

%% Investigate a simple audio effect - "stereo width expander"
%% Select individual stereo channels
left = x(:,1);
right = x(:,2);

%% Create "mid" and "side" channel
mid = (left + right) / 2;
side = (left - right) / 2;

%% Amplify side and recompose stereo signal
sidenew  = 3 * side;
leftnew = mid + sidenew;
rightnew = mid - sidenew;

xnew = [leftnew, rightnew];

%% Listen to old and new stereo signals
xoldandnew = [x; xnew];
soundsc(xoldandnew, fs)

%% Package ideas into a function
edit stereoWidth

%% Accelerate exploration
widthGain = 0;
xw = stereoWidth(x, widthGain);
plot(xw)
