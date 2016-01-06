classdef MainSettings < appbox.Settings
    
    properties
        width
        height
        monitor
        fullscreen
        type
        port
        disableDwm
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
        
        function m = get.monitor(obj)
            m = obj.get('monitor');
        end
        
        function set.monitor(obj, m)
            validateattributes(m, {'char'}, {'row'});
            obj.put('monitor', m);
        end
        
        function tf = get.fullscreen(obj)
            tf = obj.get('fullscreen');
        end
        
        function set.fullscreen(obj, tf)
            validateattributes(tf, {'logical'}, {'scalar'});
            obj.put('fullscreen', tf);
        end
        
        function t = get.type(obj)
            t = obj.get('type');
        end
        
        function set.type(obj, t)
            validateattributes(t, {'char'}, {'row'});
            obj.put('type', t);
        end
        
        function p = get.port(obj)
            p = obj.get('port');
        end
        
        function set.port(obj, p)
            validateattributes(p, {'numeric'}, {'scalar'});
            obj.put('port', p);
        end
        
        function tf = get.disableDwm(obj)
            tf = obj.get('disableDwm');
        end
        
        function set.disableDwm(obj, tf)
            validateattributes(tf, {'logical'}, {'scalar'});
            obj.put('disableDwm', tf);
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

