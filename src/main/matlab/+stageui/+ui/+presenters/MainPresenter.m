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
            try
                obj.loadSettings();
            catch x
                warning(['Failed to load presenter settings: ' x.message]);
            end
            obj.updateStateOfControls();
        end

        function onBind(obj)
            v = obj.view;
            obj.addListener(v, 'SetFullscreen', @obj.onViewSetFullscreen);
            obj.addListener(v, 'Start', @obj.onViewSelectedStart);
        end

    end

    methods (Access = private)
        
        function populateMonitorList(obj)
            monitors = stage.core.Monitor.availableMonitors();
            
            names = cell(1, numel(monitors));
            for i = 1:numel(monitors)
                res = monitors{i}.resolution;
                names{i} = [monitors{i}.name, ' (' num2str(res(1)) ' x ' num2str(res(2)) ')'];
            end
            values = monitors;
            
            obj.view.setMonitorList(names, values);
        end
        
        function onViewSetFullscreen(obj, ~, ~)
            obj.updateStateOfControls();
        end
        
        function onViewSelectedStart(obj, ~, ~)
            obj.view.update();
            
            width = obj.view.getWidth();
            height = obj.view.getHeight();
            monitor = obj.view.getSelectedMonitor();
            fullscreen = obj.view.getFullscreen();
            try
                disp(width);
                disp(height);
                disp(monitor);
                disp(fullscreen);
            catch x
                obj.view.showError(x.message);
                return;
            end
            
            try
                obj.saveSettings();
            catch x
                warning(['Failed to save presenter settings: ' x.message]);
            end
            
            obj.stop();
        end
        
        function updateStateOfControls(obj)
            fullscreen = obj.view.getFullscreen();
            obj.view.enableSelectMonitor(fullscreen);
        end

        function loadSettings(obj)
            if ~isempty(obj.settings.width)
                obj.view.setWidth(num2str(obj.settings.width));
            end
            if ~isempty(obj.settings.height)
                obj.view.setHeight(num2str(obj.settings.height));
            end
            if ~isempty(obj.settings.monitorIndex)
                i = obj.settings.monitorIndex;
                m = obj.view.getMonitorList();
                if numel(m) >= i
                    obj.view.setSelectedMonitor(m{i});
                end
            end
            if ~isempty(obj.settings.fullscreen)
                obj.view.setFullscreen(obj.settings.fullscreen);
            end
            if ~isempty(obj.settings.viewPosition)
                obj.view.position = obj.settings.viewPosition;
            end
        end

        function saveSettings(obj)
            obj.settings.width = str2double(obj.view.getWidth());
            obj.settings.height = str2double(obj.view.getHeight());
            obj.settings.monitorIndex = find(cellfun(@(m)m == obj.view.getSelectedMonitor(), obj.view.getMonitorList()));
            obj.settings.fullscreen = obj.view.getFullscreen() ~= 0;
            obj.settings.viewPosition = obj.view.position;
            obj.settings.save();
        end

    end

end
