classdef MainSettings < appbox.Settings
    
    properties
        width
        height
        monitorIndex
        fullscreen
        viewPosition
    end
    
    methods
        
        function w = get.width(obj)
            w = obj.get('width');
        end
        
        function set.width(obj, w)
            validateattributes(w, {'numeric'}, {'scalar'});
            obj.put('width', w);
        end
        
        function h = get.height(obj)
            h = obj.get('height');
        end
        
        function set.height(obj, h)
            validateattributes(h, {'numeric'}, {'scalar'});
            obj.put('height', h);
        end
        
        function i = get.monitorIndex(obj)
            i = obj.get('monitorIndex');
        end
        
        function set.monitorIndex(obj, i)
            validateattributes(i, {'numeric'}, {'scalar'});
            obj.put('monitorIndex', i);
        end
        
        function tf = get.fullscreen(obj)
            tf = obj.get('fullscreen');
        end
        
        function set.fullscreen(obj, tf)
            validateattributes(tf, {'logical'}, {'scalar'});
            obj.put('fullscreen', tf);
        end
        
        function p = get.viewPosition(obj)
            p = obj.get('viewPosition');
        end
        
        function set.viewPosition(obj, p)
            validateattributes(p, {'double'}, {'vector'});
            obj.put('viewPosition', p);
        end
        
    end
    
end

