package worlds.auxiliarys
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-30
	// ============================
	public class MapPointPool
	{
        /** 单例对像 */
        private static var _instance : MapPointPool;

        /** 获取单例对像 */
        static public function get instance() : MapPointPool
        {
            if (_instance == null)
            {
                _instance = new MapPointPool(new Singleton());
            }
            return _instance;
        }

        private const MAX_COUNT : int = 300;
        private var list : Vector.<MapPoint> = new Vector.<MapPoint>();

        function MapPointPool(singleton : Singleton)
        {
        }

        public function getObject(x:Number = 0, y:Number = 0) : MapPoint
        {
            if (list.length > 0)
            {
                var mapPoint :MapPoint= list.pop();
				mapPoint.x = x;
				mapPoint.y = y;
            }
            return new MapPoint(x, y);
        }

        public function destoryObject(object : MapPoint, destoryed:Boolean = false) : void
        {
            if (object == null) return;
            if (list.indexOf(object) != -1) return;
            if(!destoryed) object.destory();
            if (list.length < MAX_COUNT) list.push(object);
        }
    }
}
class Singleton
{
}