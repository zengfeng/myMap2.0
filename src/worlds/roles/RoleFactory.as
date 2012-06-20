package worlds.roles
{
	import game.core.avatar.AvatarThumb;
	import worlds.roles.animations.AvatarFactory;
	import worlds.roles.animations.SimpleAnimation;
	import worlds.roles.animations.SimpleAnimationPool;
	import worlds.roles.cores.Role;



	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-6
	// ============================
	public class RoleFactory
	{
		/** 单例对像 */
		private static var _instance : RoleFactory;

		/** 获取单例对像 */
		public static  function get instance() : RoleFactory
		{
			if (_instance == null)
			{
				_instance = new RoleFactory(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var rolePool : RolePool;
		private var avatarFactory : AvatarFactory;
		private var simpleAnimationPool : SimpleAnimationPool;

		function RoleFactory(singleton : Singleton) : void
		{
			singleton;
			rolePool = RolePool.instance;
			avatarFactory = AvatarFactory.instance;
			simpleAnimationPool = SimpleAnimationPool.instance;
		}

		/** 创建龟仙 */
		public function makeTurtle(quality : int, playerName : String, playerColorStr : String, name : String, colorStr : String) : Role
		{
			var role : Role = rolePool.getObject();
			var avatar : AvatarThumb = avatarFactory.makeTurtle(quality, playerName, playerColorStr, name, colorStr);
			var animation : SimpleAnimation = simpleAnimationPool.getObject();
			animation.resetSimple(avatar);
			role.initialize();
			role.setAnimation(animation);
			return role;
		}
	}
}
class Singleton
{
}