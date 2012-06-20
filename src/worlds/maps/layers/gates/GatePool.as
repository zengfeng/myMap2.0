package worlds.maps.layers.gates
{
	import flash.display.MovieClip;
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-18
	// ============================
	public class GatePool
	{/** 单例对像 */
        private static var _instance : GatePool;

        /** 获取单例对像 */
        static public function get instance() : GatePool
        {
            if (_instance == null)
            {
                _instance = new GatePool(new Singleton());
            }
            return _instance;
        }

        private var list : Vector.<MovieClip> = new Vector.<MovieClip>();
		public var GateClass:Class;

        function GatePool(singleton : Singleton)
        {
        }

        public function getObject() : MovieClip
        {
            if (list.length > 0)
            {
                return list.pop();
            }
            return new GateClass();
        }

        /**
         * 
         * @param bitmapData
         */
        public function destoryObject(gete : MovieClip) : void
        {
            if (gete == null) return;
            if (list.indexOf(gete) != -1) return;
            gete.gotoAndStop(1);
            list.push(gete);
        }
    }
}
class Singleton
{
}