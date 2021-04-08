%%Initial Matlab file for stereo effect implementation
% 4/8/2021, Eric Barkuloo
% Notes: May want to change delay implementation to some other type, I just
% used a FIR comb filter cause its easy. Also later on we can combine this
% code with the other effects to change the sound of the stereo channels in
% other ways than just the delay

%filename = 'FunkyDrums-44p1-stereo-25secs.mp3';
filename = 'sayitaintso.wav';
[xlong, fs] = audioread(filename);
%soundsc(x, fs) %Uncomment to listen to original uncut audio

start = 75*fs; %start from 75 seconds
stop = 85*fs; %end at 85 seconds
x = xlong(start:stop,1:2); %clip out part of sound to test so sound array isnt crazy long

%Select stereo channels
left = x(:,1);
right = x(:,2);

%Implementing delay with basic comb FIR filter from
%http://users.cs.cf.ac.uk/Dave.Marshall/CM0268/PDF/10_CM0268_Audio_FX.pdf

g = 0.5; %Gain control
delay_ch = 'right'; %stereo channel control, choose 'left', 'right', or 'both'
delay_am = 5000; %Delay amount (delay by 1/fs seconds)

%Code below looks big and scary but really its just the same thing 4 times
%depending on which stereo channels we are modifying
switch delay_ch
    case 'left'
        delay_buff = zeros(delay_am,1); %initialize delay buffer with zeros, use as FIFO
        for i = 1:length(left)
            left(i) = left(i) + g*delay_buff(delay_am); %Add delay to left Channel
            delay_buff = [left(i); delay_buff(1:delay_am-1)]; %shift buffer, discard oldest sample and take in new sample
        end
    case 'right'
        delay_buff = zeros(delay_am,1); %initialize delay buffer with zeros, use as FIFO
        for i = 1:length(right)
            right(i) = right(i) + g*delay_buff(delay_am); %Add delay to left Channel
            delay_buff = [right(i); delay_buff(1:delay_am-1)]; %shift buffer, discard oldest sample and take in new sample
        end
    otherwise %Delay both channels
        delay_buff1 = zeros(delay_am,1); %initialize delay buffer with zeros, use as FIFO
        delay_buff2 = zeros(delay_am,1); %initialize delay buffer with zeros, use as FIFO
        for i = 1:length(left)
            left(i) = left(i) + g*delay_buff1(delay_am); %Add delay to left Channel
            delay_buff1 = [left(i); delay_buff1(1:delay_am-1)]; %shift buffer, discard oldest sample and take in new sample
            right(i) = right(i) + g*delay_buff2(delay_am); %Add delay to left Channel
            delay_buff2 = [right(i); delay_buff2(1:delay_am-1)]; %shift buffer, discard oldest sample and take in new sample
        end
end


out = [left, right];
%soundsc(x, fs); %Uncomment these two lines to listen to original to compare
%pause;
soundsc(out, fs);

