package worlds.roles
{
	import worlds.roles.cores.Role;
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-6
	// ============================
	public class RolePool
	{
		/** 单例对像 */
		private static var _instance : RolePool;

		/** 获取单例对像 */
		public static  function get instance() : RolePool
		{
			if (_instance == null)
			{
				_instance = new RolePool(new Singleton());
			}
			return _instance;
		}

		function RolePool(singleton : Singleton) : void
		{
			singleton;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private const MAX_COUNT : int = 200;
		private var list : Vector.<Role > = new Vector.<Role>();

		public function getObject() : Role
		{
			if (list.length > 0)
			{
				return list.shift();
			}
			return new Role();
		}

		public function destoryObject(object : Role, destoryed : Boolean = false) : void
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