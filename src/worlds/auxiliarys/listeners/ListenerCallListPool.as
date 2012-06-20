package worlds.auxiliarys.listeners
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-19
	// ============================
	public class ListenerCallListPool
	{
		/** 单例对像 */
		private static var _instance : ListenerCallListPool;

		/** 获取单例对像 */
		public static  function get instance() : ListenerCallListPool
		{
			if (_instance == null)
			{
				_instance = new ListenerCallListPool(new Singleton());
			}
			return _instance;
		}

		function ListenerCallListPool(singleton : Singleton) : void
		{
			singleton;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private const MAX_COUNT : int = 200;
		private var list : Array = new Array();

		public function getObject() : ListenerCallList
		{
			if (list.length > 0)
			{
				return list.shift();
			}
			return new ListenerCallList();
		}

		public function destoryObject(object : ListenerCallList, destoryed : Boolean = false) : void
		{
			if (object == null) return;
			if (list.indexOf(object) != -1) return;
			if (!destoryed) object.destory();
			if (list.length < MAX_COUNT) list.push(object);
		}
	}
}
class Singleton
{
}