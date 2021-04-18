classdef Convolver < audioPlugin
        properties (Constant)
            % audioPluginInterface manages the number of input/output channels
            % and uses audioPluginParameter to generate plugin UI parameters.
            PluginInterface = audioPluginInterface(...
                'InputChannels',2,...
                'OutputChannels',2,...
                'PluginName','Stereo Convolver'...
                );
            IR = audioread('Concert_IR.aif');
            PartitionSize = 1024;
        end
        properties(Access = private)
            pFIR_L
            pFIR_R 
        end
        methods
            
            function plugin = Stereo_Convolver_Basic
                plugin.pFIR_L = dsp.FrequencyDomainFIRFilter('Numerator', plugin.IR(:,1).', ...
                    'PartitionForReducedLatency', true, 'PartitionLength', plugin.PartitionSize);
                plugin.pFIR_R = dsp.FrequencyDomainFIRFilter('Numerator', plugin.IR(:,2).', ...
                    'PartitionForReducedLatency', true, 'PartitionLength', plugin.PartitionSize);
            end
            
            function y = process(plugin,u)
                x = u(:,1)+u(:,2);
                x = x * 0.5;
                yL = step(plugin.pFIR_L,x);
                yR = step(plugin.pFIR_R,x);
                y = [yL,yR];
            end
        end
    end