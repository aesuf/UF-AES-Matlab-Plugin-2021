function out = delay_function(in,type, bypass, mix, L_Gain,R_Gain,L_Delay,R_Delay,L_Feedback,R_Feedback,fs)
%Parameters: in = input data, type = type of delay, 
%L_Gain/R_gain = gain on delayed data, L_Delay/R_Delay = delay amount (ms),
%L_Feedback/R_Feedback = feedback amount(0-1), fs = sampling frequency

dry = in; %use input to get wet/dry data for mixing
wet = in;

BP = 1;
if(bypass)
    BP = 0;
end

left_in = in(:,1);
right_in = in(:,2);
left_out = in(:,1);
right_out = in(:,2);

L_Delay = fs*L_Delay/1000; %Convert to Samples from ms
R_Delay = fs*R_Delay/1000;
L_delay_buff = zeros(L_Delay,1); %initialize delay buffers with 0's
R_delay_buff = zeros(R_Delay,1);
L_feedback_buff = zeros(L_Delay,1);
R_feedback_buff = zeros(R_Delay,1);

switch type
    case "basic"
        %Basic delay implementation
        for i = 1:length(left_in)
            %Apply delay and update buffers for LEFT
            left_out(i) = left_in(i) + BP*L_Gain*L_delay_buff(L_Delay) + 0*BP*L_Feedback*L_feedback_buff(L_Delay);
            L_delay_buff = [left_in(i); L_delay_buff(1:L_Delay-1)];
            L_feedback_buff = [left_out(i); L_feedback_buff(1:L_Delay-1)];
            %Apply delay and update buffers for RIGHT
            right_out(i) = right_in(i) + BP*R_Gain*R_delay_buff(R_Delay) + 0*BP*R_Feedback*R_feedback_buff(R_Delay);
            R_delay_buff = [right_in(i); R_delay_buff(1:R_Delay-1)];
            R_feedback_buff = [right_out(i); R_feedback_buff(1:R_Delay-1)];
        end
    case "ping-pong"
        %Ping-Pong delay
    case "tape"
        %Tape delay
    otherwise
        %By default use basic delay
end

wet = [left_out,right_out];
out(:,1) = (1-mix)*dry(:,1) + (mix)*wet(:,1);
out(:,2) = (1-mix)*dry(:,2) + (mix)*wet(:,2);
end