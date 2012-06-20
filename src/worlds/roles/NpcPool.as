package worlds.roles
{
	import worlds.roles.cores.Npc;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	// ============================
	public class NpcPool
	{
		/** 单例对像 */
		private static var _instance : NpcPool;

		/** 获取单例对像 */
		public static  function get instance() : NpcPool
		{
			if (_instance == null)
			{
				_instance = new NpcPool(new Singleton());
			}
			return _instance;
		}

		function NpcPool(singleton : Singleton) : void
		{
			singleton;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private const MAX_COUNT : int = 50;
		private var list : Vector.<Npc > = new Vector.<Npc>();

		public function getObject() : Npc
		{
			if (list.length > 0)
			{
				return list.shift();
			}

			return new Npc();
		}

		public function destoryObject(object : Npc, destoryed : Boolean = false) : void
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