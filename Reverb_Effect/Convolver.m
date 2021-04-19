classdef Convolver < audioPlugin
        properties (Constant)
            % audioPluginInterface manages the number of input/output channels
            % and uses audioPluginParameter to generate plugin UI parameters.
           
            IR = audioread('Hall.aif');

            PartitionSize = 1024;
        end
        properties(Access = private)
            pFIR_L
            pFIR_R 
        end
        methods
            

            function plugin = Convolver
%             [frameLength,~] = size(plugin.deviceReader);
%             if (frameLength == 1)
%                 plugin.PartitionSize = 1024;
%             else
%                 plugin.PartitionSize = frameLength;
%             end
                plugin.pFIR_L = dsp.FrequencyDomainFIRFilter('Numerator', plugin.IR(:,1).', ...
                    'PartitionForReducedLatency', true, 'PartitionLength', plugin.PartitionSize);
                plugin.pFIR_R = dsp.FrequencyDomainFIRFilter('Numerator', plugin.IR(:,2).', ...
                    'PartitionForReducedLatency', true, 'PartitionLength', plugin.PartitionSize);
            end
            
            function out = process(plugin,in)
                outL = step(plugin.pFIR_L,in(:,1));
                outR = step(plugin.pFIR_R,in(:,2));
                out = [outL,outR];
            end
        end
end