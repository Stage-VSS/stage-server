classdef MainPresenter < appbox.Presenter

    properties (Access = private)
        settings
    end

    methods

        function obj = MainPresenter(view)
            if nargin < 1
                view = stageui.ui.views.MainView();
            end
            obj = obj@appbox.Presenter(view);
            
            obj.settings = stageui.ui.settings.MainSettings();
        end

    end

    methods (Access = protected)

        function onGoing(obj)
            obj.view.setWidth('640');
            obj.view.setHeight('480');
            obj.populateMonitorList();
            obj.view.setPort('5678');
            obj.view.setDisableDwm(true);
            try
                obj.loadSettings();
            catch x
                warning(['Failed to load presenter settings: ' x.message]);
            end
            obj.updateStateOfControls();
        end

        function onBind(obj)
            v = obj.view;
            obj.addListener(v, 'SetFullscreen', @obj.onViewSelectedSetFullscreen);
            obj.addListener(v, 'MinimizeAdvanced', @obj.onViewSelectedMinimizeAdvanced);
            obj.addListener(v, 'Start', @obj.onViewSelectedStart);
            obj.addListener(v, 'Cancel', @obj.onViewSelectedCancel);
        end

    end

    methods (Access = private)
        
        function populateMonitorList(obj)
            monitors = stage.core.Monitor.availableMonitors();
            
            names = cell(1, numel(monitors));
            for i = 1:numel(monitors)
                res = monitors{i}.resolution;
                names{i} = [monitors{i}.name ' (' num2str(res(1)) ' x ' num2str(res(2)) ')'];
            end
            values = monitors;
            
            obj.view.setMonitorList(names, values);
        end
        
        function onViewSelectedSetFullscreen(obj, ~, ~)
            obj.updateStateOfControls();
        end
        
        function onViewSelectedMinimizeAdvanced(obj, ~, ~)
            if obj.view.isAdvancedMinimized()
                obj.maximizeAdvanced();
            else
                obj.minimizeAdvanced();
            end
        end
        
        function minimizeAdvanced(obj)
            delta = obj.view.getAdvancedHeight() - obj.view.getAdvancedMinimumHeight();
            obj.view.setViewHeight(obj.view.getViewHeight() - delta);
            obj.view.setAdvancedHeight(obj.view.getAdvancedHeight() - delta);
            obj.view.setAdvancedMinimized(true);
        end
        
        function maximizeAdvanced(obj)
            delta = 70;
            obj.view.setViewHeight(obj.view.getViewHeight() + delta);
            obj.view.setAdvancedHeight(obj.view.getAdvancedHeight() + delta);
            obj.view.setAdvancedMinimized(false);
        end
        
        function updateStateOfControls(obj)
            fullscreen = obj.view.getFullscreen();
            obj.view.enableSelectMonitor(fullscreen);
        end
        
        function onViewSelectedStart(obj, ~, ~)
            obj.view.update();
            
            width = str2double(obj.view.getWidth());
            height = str2double(obj.view.getHeight());
            monitor = obj.view.getSelectedMonitor();
            fullscreen = obj.view.getFullscreen();
            port = str2double(obj.view.getPort());
            disableDwm = obj.view.getDisableDwm();
            try
                server = stage.core.network.StageServer(port);
                
                obj.view.hide();
                obj.view.update();
                
                server.start([width, height], fullscreen, monitor, 'disableDwm', disableDwm);
            catch x
                obj.view.showError(x.message);
                obj.view.show();
                return;
            end
            
            try
                obj.saveSettings();
            catch x
                warning(['Failed to save presenter settings: ' x.message]);
            end
            
            obj.stop();
        end
        
        function onViewSelectedCancel(obj, ~, ~)
            obj.stop();
        end

        function loadSettings(obj)
            if ~isempty(obj.settings.width)
                obj.view.setWidth(num2str(obj.settings.width));
            end
            if ~isempty(obj.settings.height)
                obj.view.setHeight(num2str(obj.settings.height));
            end
            if ~isempty(obj.settings.monitor)
                list = obj.view.getMonitorList();
                for i = 1:numel(list)
                    m = list{i};
                    if strcmp([m.name ' (' num2str(m.resolution(1)) ' x ' num2str(m.resolution(2)) ')'], obj.settings.monitor)
                        obj.view.setSelectedMonitor(m);
                        break;
                    end
                end
            end
            if ~isempty(obj.settings.fullscreen)
                obj.view.setFullscreen(obj.settings.fullscreen);
            end
            if ~isempty(obj.settings.port)
                obj.view.setPort(num2str(obj.settings.port));
            end
            if ~isempty(obj.settings.disableDwm)
                obj.view.setDisableDwm(obj.settings.disableDwm);
            end
            if ~isempty(obj.settings.viewPosition)
                obj.view.position = obj.settings.viewPosition;
            end
        end

        function saveSettings(obj)
            obj.settings.width = str2double(obj.view.getWidth());
            obj.settings.height = str2double(obj.view.getHeight());
            monitor = obj.view.getSelectedMonitor();
            obj.settings.monitor = [monitor.name ' (' num2str(monitor.resolution(1)) ' x ' num2str(monitor.resolution(2)) ')'];
            obj.settings.fullscreen = obj.view.getFullscreen() ~= 0;
            obj.settings.port = str2double(obj.view.getPort());
            obj.settings.disableDwm = obj.view.getDisableDwm() ~= 0;
            position = obj.view.position;
            if ~obj.view.isAdvancedMinimized()
                delta = obj.view.getAdvancedHeight() - obj.view.getAdvancedMinimumHeight();
                position(2) = position(2) + delta;
                position(4) = position(4) - delta;
            end
            obj.settings.viewPosition = position;
            obj.settings.save();
        end

    end

end
