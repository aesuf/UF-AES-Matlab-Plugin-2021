function y = stereoWidth(x, widthGain)

% Copyright 2016-2019 The MathWorks, Inc.

% Decompose stereo input into mid and side
mid = (x(:,1) + x(:,2)) / 2;
side = (x(:,1) - x(:,2)) / 2;

% Amplify side
side = side * widthGain;

% Recombine
y = [mid + side,   mid - side];
