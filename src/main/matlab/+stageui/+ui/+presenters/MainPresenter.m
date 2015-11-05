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
            try
                obj.loadSettings();
            catch x
                warning(['Failed to load presenter settings: ' x.message]);
            end
        end

        function onStopping(obj)
            try
                obj.saveSettings();
            catch x
                warning(['Failed to save presenter settings: ' x.message]);
            end
        end

        function onBind(obj)
            v = obj.view;
        end

    end

    methods (Access = private)

        function loadSettings(obj)
            if ~isempty(obj.settings.viewPosition)
                obj.view.position = obj.settings.viewPosition;
            end
        end

        function saveSettings(obj)
            obj.settings.viewPosition = obj.view.position;
            obj.settings.save();
        end

    end

end
