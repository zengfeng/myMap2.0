package worlds.roles.animations
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-6
	// ============================
	public class SimpleAnimationPool
	{
		/** 单例对像 */
		private static var _instance : SimpleAnimationPool;

		/** 获取单例对像 */
		public static  function get instance() : SimpleAnimationPool
		{
			if (_instance == null)
			{
				_instance = new SimpleAnimationPool(new Singleton());
			}
			return _instance;
		}

		function SimpleAnimationPool(singleton : Singleton) : void
		{
			singleton;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private const MAX_COUNT : int = 200;
		private var list : Vector.<SimpleAnimation > = new Vector.<SimpleAnimation>();

		public function getObject() : SimpleAnimation
		{
			if (list.length > 0)
			{
				return list.shift();
			}

			return new SimpleAnimation();
		}

		public function destoryObject(object : SimpleAnimation, destoryed : Boolean = false) : void
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