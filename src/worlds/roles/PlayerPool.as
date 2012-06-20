package worlds.roles
{
	import worlds.roles.cores.Player;
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-7
	// ============================
	public class PlayerPool
	{
		/** 单例对像 */
		private static var _instance : PlayerPool;

		/** 获取单例对像 */
		public static  function get instance() : PlayerPool
		{
			if (_instance == null)
			{
				_instance = new PlayerPool(new Singleton());
			}
			return _instance;
		}

		function PlayerPool(singleton : Singleton) : void
		{
			singleton;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private const MAX_COUNT : int = 200;
		private var list : Vector.<Player > = new Vector.<Player>();

		public function getObject() : Player
		{
			if (list.length > 0)
			{
				return list.shift();
			}
			return new Player();
		}

		public function destoryObject(object : Player, destoryed : Boolean = false) : void
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