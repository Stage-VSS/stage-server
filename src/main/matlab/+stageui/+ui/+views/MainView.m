classdef MainView < appbox.View

    events
        
    end

    properties (Access = private)
        
    end

    methods

        function createUi(obj)
            import appbox.*;
            
            set(obj.figureHandle, ...
                'Name', 'Stage Server', ...
            	'Position', screenCenter(360, 340));
        end

    end

end
