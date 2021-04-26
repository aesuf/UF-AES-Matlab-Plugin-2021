function y = stereoDelay(x,L_Gain,R_Gain,L_Delay,R_Delay, fs)
%Delay function taking L and R Gain (0-1), and L and R Delay (ms)
left = x(:,1);
right = x(:,2);

L_Delay = fs*L_Delay/1000; %Convert to Samples
R_Delay = fs*R_Delay/1000;
L_delay_buff = zeros(L_Delay,1); %initialize delay buffers with 0's
R_delay_buff = zeros(R_Delay,1);

for i = 1:length(left)
    left(i) = left(i) + L_Gain*L_delay_buff(L_Delay);
    L_delay_buff = [left(i); L_delay_buff(1:L_delay_buff-1)];
    right(i) = right(i) + R_Gain*R_delay_buff(R_Delay);
    R_delay_buff = [right(i); R_delay_buff(0:R_delay_buff-1)];
end
y = [left,right];
