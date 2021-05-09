function [out] = saturation_function(in, bypass, mix, type, in_gain, dist_gain)
%Parameters: in = input signal, bypass = boolean to bypass effect,
% mix = wet/dry ration, type = type of saturation, in_gain = input gain,
% dist_gain = gain on distortion effect

dry = in; %use input to get wet/dry data for mixing
wet = in; 

BP = 1;
if(bypass)
    BP = 0;
end

%apply effects to wet data
switch type
    case "cubic"
        %Cubic distortion
        wet(:,1) = in_gain*in(:,1) - BP*dist_gain*(1/3)*in(:,1).^3;
        wet(:,2) = in_gain*in(:,2) - BP*dist_gain*(1/3)*in(:,2).^3;
    case "arctan"
        %arctan distortion
        wet(:,1) = (2/pi)*atan(in(:,1).*dist_gain); 
        wet(:,2) = (2/pi)*atan(in(:,2).*dist_gain);
    case "tanh"
        %tanh distortion
        wet(:,1) = tanh(in(:,1).*dist_gain); 
        wet(:,2) = tanh(in(:,2).*dist_gain);
    case "sinh"
        %sinh distortion
        %sinh has no y limit, what do I scale it by? 
        wet(:,1) = sinh(in(:,1).*dist_gain); 
        wet(:,2) = sinh(in(:,2).*dist_gain);
    otherwise
        %Default to cubic distortion
        wet(:,1) = in_gain*in(:,1) - BP*dist_gain*(1/3)*in(:,1).^3;
        wet(:,2) = in_gain*in(:,2) - BP*dist_gain*(1/3)*in(:,2).^3;
end
%Mix data into output
out(:,1) = (1-mix)*dry(:,1) + (mix)*wet(:,1);
out(:,2) = (1-mix)*dry(:,2) + (mix)*wet(:,2);
end
