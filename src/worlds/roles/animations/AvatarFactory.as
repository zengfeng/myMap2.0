package worlds.roles.animations
{
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarMonster;
	import game.core.avatar.AvatarNpc;
	import game.core.avatar.AvatarPlayer;
	import game.core.avatar.AvatarThumb;
	import game.core.avatar.AvatarTurtle;
	import game.core.avatar.AvatarType;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-29
	// ============================
	public class AvatarFactory
	{
		/** 单例对像 */
		private static var _instance : AvatarFactory;

		/** 获取单例对像 */
		public static  function get instance() : AvatarFactory
		{
			if (_instance == null)
			{
				_instance = new AvatarFactory(new Singleton());
			}
			return _instance;
		}

		function AvatarFactory(singleton : Singleton) : void
		{
			singleton;
			avatarManager = AvatarManager.instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var avatarManager : AvatarManager;

		// ===================
		// 内部方法
		// ===================
		private function destoryAvatar(avatar : AvatarThumb) : void
		{
			avatarManager.removeAvatar(avatar);
		}

		public function makeSelfPlayer(heroId : int, clothId : int, rideId : int, name : String, colorStr : String) : AvatarPlayer
		{
			var avatar : AvatarPlayer = avatarManager.getAvatar(heroId, AvatarType.MY_AVATAR, clothId) as AvatarPlayer;
			avatar.setName(name, colorStr);
			if (rideId) avatar.addSeat(rideId);
			return avatar;
		}

		public function makePlayer(heroId : int, clothId : int, rideId : int, name : String, colorStr : String) : AvatarPlayer
		{
			var avatar : AvatarPlayer = avatarManager.getAvatar(heroId, AvatarType.PLAYER_RUN, clothId) as AvatarPlayer;
			avatar.setName(name, colorStr);
			if (rideId) avatar.addSeat(rideId);
			return avatar;
		}

		public function makeNpc(npcId : int) : AvatarNpc
		{
			var avatar : AvatarNpc = avatarManager.getAvatar(npcId, AvatarType.NPC_TYPE, 0) as  AvatarNpc;
			return avatar;
		}

		public function makeMonster(avatarId : int) : AvatarMonster
		{
			var avatar : AvatarMonster = avatarManager.getAvatar(avatarId, AvatarType.MONSTER_TYPE, 0) as  AvatarMonster;
			return avatar;
		}

		public function makeTurtle(quality : int, playerName : String, playerColorStr : String, name : String, colorStr : String) : AvatarTurtle
		{
			name = "<p align='center'><font color='" + colorStr + "'>" + name + "</font>\n<font color='" + playerColorStr + "'>(" + playerName + ")</font></p>";
			var avatar : AvatarTurtle = avatarManager.getAvatar(5012, AvatarType.TURTLE_AVATAR, 0) as AvatarTurtle;
			avatar.setName(name, colorStr);
			avatar.setQuality(quality);
			return avatar;
		}

		// ===================
		// 静态方法
		// ===================
		public static function destoryAvatar(avatar : AvatarThumb) : void
		{
			instance.destoryAvatar(avatar);
		}
	}
}
class Singleton
{
}