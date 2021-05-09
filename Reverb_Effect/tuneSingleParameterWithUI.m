function hfig = tuneSingleParameterWithUI(obj, propName, min, max)
% Copyright 2016 The MathWorks, Inc.

% Initialize simple UI to control signal streaming
basicControls

    function basicControls
        scrsz = get(groot,'ScreenSize');
        hfig = uifigure('Name', 'Tuning Control',...
            'Position', (1/10)*[1 4 1.5 0.9].*[scrsz(3) scrsz(4) scrsz(3) scrsz(4)]);
        uislider(hfig,'Limits', [min, max],...
            'Position', (1/10)*[0.1 0.5 1.3 3].*[scrsz(3) scrsz(4) scrsz(3) 10],...
            'ValueChangingFcn',@(sld,event) onSliderMoving(sld,event) );
    end

    function onSliderMoving(~,event)
        obj.(propName) = event.Value;
    end

end


