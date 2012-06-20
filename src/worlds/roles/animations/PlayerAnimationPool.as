package worlds.roles.animations
{

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-1
	// ============================
	public class PlayerAnimationPool
	{
		/** 单例对像 */
		private static var _instance : PlayerAnimationPool;

		/** 获取单例对像 */
		public static  function get instance() : PlayerAnimationPool
		{
			if (_instance == null)
			{
				_instance = new PlayerAnimationPool(new Singleton());
			}
			return _instance;
		}

		function PlayerAnimationPool(singleton : Singleton) : void
		{
			singleton;
			avatarFactory = AvatarFactory.instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var avatarFactory : AvatarFactory;
		private const MAX_COUNT : int = 200;
		private var list : Vector.<PlayerAnimation > = new Vector.<PlayerAnimation>();

		public function getObject() : PlayerAnimation
		{
			if (list.length > 0)
			{
				return list.shift();
			}
			return new PlayerAnimation();
		}

		public function destoryObject(object : PlayerAnimation, destoryed : Boolean = false) : void
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
