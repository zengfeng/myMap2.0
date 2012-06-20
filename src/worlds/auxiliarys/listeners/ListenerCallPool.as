package worlds.auxiliarys.listeners
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-19
	// ============================
	public class ListenerCallPool
	{
		/** 单例对像 */
		private static var _instance : ListenerCallPool;

		/** 获取单例对像 */
		public static  function get instance() : ListenerCallPool
		{
			if (_instance == null)
			{
				_instance = new ListenerCallPool(new Singleton());
			}
			return _instance;
		}

		function ListenerCallPool(singleton : Singleton) : void
		{
			singleton;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private const MAX_COUNT : int = 300;
		private var list : Array = new Array();
		

		public function getObject(fun : Function = null, args : Array = null) : ListenerCall
		{
			if (list.length > 0)
			{
				var call : ListenerCall = list.shift();
				if (fun != null) call.register(fun, args);
				return call;
			}
			return new ListenerCall(fun, args);
		}

		public function destoryObject(object : ListenerCall, destoryed : Boolean = false) : void
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