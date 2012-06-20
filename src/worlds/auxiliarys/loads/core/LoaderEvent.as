package worlds.auxiliarys.loads.core
{
    import flash.events.Event;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class LoaderEvent extends Event
    {
		public static const OPEN:String="open";
		public static const PROGRESS:String="progress";
        public static const COMPLETE : String = "complete";
        public static const HTTP_STATUS : String = "httpStatus";
        public static const OVERTIME : String = "overtime";
        public static const INIT : String = "init";
        public static const ERROR : String = "error";
        public static const IO_ERROR : String = "ioError";
        public static const SECURITY_ERROR : String = "securityError";
        public static const UNCAUGHT_ERROR : String = "uncaughtError";
        public static const UNLOAD : String = "unload";
		public static const FAIL:String="fail";
        public static const CANCEL : String = "cancel";
        
        private var _target : Object;
        public var text : String;

        public function LoaderEvent(type : String, target : Object, text : String = null)
        {
            super(type, false, false);
            _target = target;
            this.text = text;
        }

        override public function get target() : Object
        {
            return _target;
        }

        override public function clone() : Event
        {
            return new LoaderEvent(this.type, _target, this.text);
        }
        
        public function destory():void
        {
            _target = null;
            text = null;
        }
    }
}
