function [out] = reverb_effect(in, ir, bypass, mix)
    %Function to take in a signal and convole it with a reverberation
    %impulse response.
    
    %Using Convulation: Slower for larger samples
%     out_L = conv(in(:,1),ir(:,1));
%     out_R = conv(in(:,2),ir(:,2));
%     out=[out_L, out_R];
    
    %Using FFT/IFFT: Faster for larger samples, slower for smaller samps
    in_L_freq = fft(in(:,1));
    in_R_freq = fft(in(:,2));
    ir_L_freq = fft(ir(:,1));
    ir_R_freq = fft(ir(:,2));
    
    %HANDLE ZERO PADDING SO VECTORS ARE SAME LENGTHS
    if length(in_L_freq) > length(ir_L_freq)
        %zero pad ir_L_freq+ir_R_freq
        L1 = length(in_L_freq);
        L2 = length(ir_L_freq);
        ir_L_freq = [ir_L_freq; zeros(L1-L2,1)];
        ir_R_freq = [ir_R_freq; zeros(L1-L2,1)];
    elseif length(ir_L_freq) > length(in_L_freq)
        %zero pad in_L_freq+in_R_freq
        L1 = length(ir_L_freq);
        L2 = length(in_L_freq);
        in_L_freq = [in_L_freq zeros(L1-L2,1)];
        in_L_freq = [in_L_freq zeros(L1-L2,1)];
    end
    
    out_L = ifft(in_L_freq.*ir_L_freq);
    out_R = ifft(in_R_freq.*ir_R_freq);

    dry = in;
    wet = [out_L, out_R];
    if bypass
        wet = in;
    end

    out(:,1) = (1-mix)*dry(:,1) + (mix)*wet(:,1);
    out(:,2) = (1-mix)*dry(:,2) + (mix)*wet(:,2);
end