classdef MainPresenter < appbox.Presenter

    properties (Access = private)
        
    end

    methods

        function obj = MainPresenter(view)
            if nargin < 1
                view = stagenet.ui.views.MainView();
            end
            obj = obj@appbox.Presenter(view);
        end

    end

    methods (Access = protected)

        function onGoing(obj)
            try
                obj.loadSettings();
            catch x
                obj.log.debug(['Failed to load presenter settings: ' x.message], x);
            end
        end

        function onStopping(obj)
            try
                obj.saveSettings();
            catch x
                obj.log.debug(['Failed to save presenter settings: ' x.message], x);
            end
        end

        function onBind(obj)
            v = obj.view;
        end

    end

    methods (Access = private)

        function loadSettings(obj)
            
        end

        function saveSettings(obj)
            
        end

    end

end
