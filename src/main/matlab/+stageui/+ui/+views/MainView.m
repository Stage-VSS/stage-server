classdef MainView < appbox.View

    events
        SetFullscreen
        Start
    end

    properties (Access = private)
        widthField
        heightField
        monitorPopupMenu
        fullscreenCheckbox
        startButton
    end

    methods

        function createUi(obj)
            import appbox.*;
            
            set(obj.figureHandle, ...
                'Name', 'Stage Server', ...
            	'Position', screenCenter(325, 212));
            
            mainLayout = uix.VBox( ...
                'Parent', obj.figureHandle, ...
                'Padding', 11, ...
                'Spacing', 7);
            
            windowPanel = uix.Panel( ...
                'Parent', mainLayout, ...
                'Title', 'Window', ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'), ...
                'Padding', 11);
            
            windowLayout = uix.Grid( ...
                'Parent', windowPanel, ...
                'Spacing', 7);
            Label( ...
                'Parent', windowLayout, ...
                'String', 'Width:');
            Label( ...
                'Parent', windowLayout, ...
                'String', 'Height:');
            Label( ...
                'Parent', windowLayout, ...
                'String', 'Monitor:');
            Label( ...
                'Parent', windowLayout, ...
                'String', 'Fullscreen:');
            obj.widthField = uicontrol( ...
                'Parent', windowLayout, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left');
            obj.heightField = uicontrol( ...
                'Parent', windowLayout, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left');
            obj.monitorPopupMenu = MappedPopupMenu( ...
                'Parent', windowLayout, ...
                'String', {' '}, ...
                'HorizontalAlignment', 'left');
            obj.fullscreenCheckbox = uicontrol( ...
                'Parent', windowLayout, ...
                'Style', 'checkbox', ...
                'HorizontalAlignment', 'left', ...
                'Callback', @(h,d)notify(obj, 'SetFullscreen'));
            set(windowLayout, ...
                'Widths', [60 -1], ...
                'Heights', [25 25 25 25]);
            
            % Start control.
            controlsLayout = uix.HBox( ...
                'Parent', mainLayout, ...
                'Spacing', 7);
            uix.Empty('Parent', controlsLayout);
            obj.startButton = uicontrol( ...
                'Parent', controlsLayout, ...
                'Style', 'pushbutton', ...
                'String', 'Start', ...
                'Interruptible', 'off', ...
                'Callback', @(h,d)notify(obj, 'Start'));
            set(controlsLayout, 'Widths', [-1 75]);
            
            set(mainLayout, 'Heights', [-1 25]);
            
            % Set start button to appear as the default button.
            try %#ok<TRYNC>
                h = handle(obj.figureHandle);
                h.setDefaultButton(obj.startButton);
            end
        end
        
        function w = getWidth(obj)
            w = get(obj.widthField, 'String');
        end
        
        function setWidth(obj, w)
            set(obj.widthField, 'String', w);
        end
        
        function h = getHeight(obj)
            h = get(obj.heightField, 'String');
        end
        
        function setHeight(obj, h)
            set(obj.heightField, 'String', h);
        end
        
        function enableSelectMonitor(obj, tf)
            set(obj.monitorPopupMenu, 'Enable', appbox.onOff(tf));
        end
        
        function m = getSelectedMonitor(obj)
            m = get(obj.monitorPopupMenu, 'Value');
        end
        
        function setSelectedMonitor(obj, m)
            set(obj.monitorPopupMenu, 'Value', m);
        end
        
        function l = getMonitorList(obj)
            l = get(obj.monitorPopupMenu, 'Values');
        end
        
        function setMonitorList(obj, names, values)
            set(obj.monitorPopupMenu, 'String', names);
            set(obj.monitorPopupMenu, 'Values', values);
        end
        
        function tf = getFullscreen(obj)
            tf = get(obj.fullscreenCheckbox, 'Value');
        end
        
        function setFullscreen(obj, tf)
            set(obj.fullscreenCheckbox, 'Value', tf);
        end

    end

end
