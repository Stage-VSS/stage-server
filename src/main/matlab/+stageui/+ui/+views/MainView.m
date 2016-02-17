classdef MainView < appbox.View

    events
        SetFullscreen
        MinimizeAdvanced
        Start
        Cancel
    end

    properties (Access = private)
        parametersLayout
        standardBox
        widthField
        heightField
        monitorPopupMenu
        fullscreenCheckbox
        advancedBox
        portField
        disableDwmCheckbox
        startButton
        cancelButton
    end

    methods

        function createUi(obj)
            import appbox.*;
            
            set(obj.figureHandle, ...
                'Name', 'Stage Server', ...
            	'Position', screenCenter(300, 211));
            
            mainLayout = uix.VBox( ...
                'Parent', obj.figureHandle);
            
            obj.parametersLayout = uix.VBox( ...
                'Parent', mainLayout);
            
            obj.standardBox = uix.BoxPanel( ...
                'Parent', obj.parametersLayout, ...
                'Title', 'Standard', ...
                'BorderType', 'none', ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'), ...
                'Padding', 11);
            
            standardLayout = uix.Grid( ...
                'Parent', obj.standardBox, ...
                'Spacing', 7);
            Label( ...
                'Parent', standardLayout, ...
                'String', 'Width:');
            Label( ...
                'Parent', standardLayout, ...
                'String', 'Height:');
            Label( ...
                'Parent', standardLayout, ...
                'String', 'Monitor:');
            Label( ...
                'Parent', standardLayout, ...
                'String', 'Fullscreen:');
            obj.widthField = uicontrol( ...
                'Parent', standardLayout, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left');
            obj.heightField = uicontrol( ...
                'Parent', standardLayout, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left');
            obj.monitorPopupMenu = MappedPopupMenu( ...
                'Parent', standardLayout, ...
                'String', {' '}, ...
                'HorizontalAlignment', 'left');
            obj.fullscreenCheckbox = uicontrol( ...
                'Parent', standardLayout, ...
                'Style', 'checkbox', ...
                'HorizontalAlignment', 'left', ...
                'Callback', @(h,d)notify(obj, 'SetFullscreen'));
            set(standardLayout, ...
                'Widths', [80 -1], ...
                'Heights', [23 23 23 23]);
            
            obj.advancedBox = uix.BoxPanel( ...
                'Parent', obj.parametersLayout, ...
                'Title', 'Advanced', ...
                'BorderType', 'none', ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'), ...
                'Padding', 11, ...
                'Minimized', true, ...
                'MinimizeFcn', @(h,d)notify(obj, 'MinimizeAdvanced'));
            advancedLayout = uix.Grid( ...
                'Parent', obj.advancedBox, ...
                'Spacing', 7);
            
            Label( ...
                'Parent', advancedLayout, ...
                'String', 'Port:');
            Label( ...
                'Parent', advancedLayout, ...
                'String', 'Disable DWM:');
            obj.portField = uicontrol( ...
                'Parent', advancedLayout, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left');
            obj.disableDwmCheckbox = uicontrol( ...
                'Parent', advancedLayout, ...
                'Style', 'checkbox', ...
                'HorizontalAlignment', 'left');
            set(advancedLayout, ...
                'Widths', [80 -1], ...
                'Heights', [23 23]);
            
            set(obj.parametersLayout, ...
                'Heights', [-1 17], ...
                'MinimumHeights', [149 17]);
            
            % Start control.
            controlsLayout = uix.HBox( ...
                'Parent', mainLayout, ...
                'Padding', 11, ...
                'Spacing', 7);
            uix.Empty('Parent', controlsLayout);
            obj.startButton = uicontrol( ...
                'Parent', controlsLayout, ...
                'Style', 'pushbutton', ...
                'String', 'Start', ...
                'Interruptible', 'off', ...
                'Callback', @(h,d)notify(obj, 'Start'));
            obj.cancelButton = uicontrol( ...
                'Parent', controlsLayout, ...
                'Style', 'pushbutton', ...
                'String', 'Cancel', ...
                'Interruptible', 'off', ...
                'Callback', @(h,d)notify(obj, 'Cancel'));
            set(controlsLayout, 'Widths', [-1 75 75]);
            
            set(mainLayout, 'Heights', [-1 23+11+11]);
            
            % Set start button to appear as the default button.
            try %#ok<TRYNC>
                h = handle(obj.figureHandle);
                h.setDefaultButton(obj.startButton);
            end
        end
        
        function h = getViewHeight(obj)
            p = get(obj.figureHandle, 'Position');
            h = p(4);
        end

        function setViewHeight(obj, h)
            p = get(obj.figureHandle, 'Position');
            delta = p(4) - h;
            set(obj.figureHandle, 'Position', p + [0 delta 0 -delta]);
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
        
        function tf = isAdvancedMinimized(obj)
            tf = get(obj.advancedBox, 'Minimized');
        end
        
        function setAdvancedMinimized(obj, tf)
            set(obj.advancedBox, 'Minimized', tf);
        end
        
        function h = getAdvancedMinimumHeight(obj)
            heights = get(obj.parametersLayout, 'MinimumHeights');
            h = heights(2);
        end

        function h = getAdvancedHeight(obj)
            heights = get(obj.parametersLayout, 'Heights');
            h = heights(2);
        end
        
        function setAdvancedHeight(obj, h)
            heights = get(obj.parametersLayout, 'Heights');
            heights(2) = h;
            set(obj.parametersLayout, 'Heights', heights);
        end
        
        function p = getPort(obj)
            p = get(obj.portField, 'String');
        end
        
        function setPort(obj, p)
            set(obj.portField, 'String', p);
        end
        
        function tf = getDisableDwm(obj)
            tf = get(obj.disableDwmCheckbox, 'Value');
        end
        
        function setDisableDwm(obj, tf)
            set(obj.disableDwmCheckbox, 'Value', tf);
        end

    end

end
