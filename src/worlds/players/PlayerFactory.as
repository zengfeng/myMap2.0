package worlds.players
{
	import worlds.apis.MapUtil;
	import worlds.apis.MPlayer;
	import game.core.avatar.AvatarPlayer;
	import game.core.avatar.AvatarThumb;

	import worlds.apis.MMouse;
	import worlds.apis.MTo;
	import worlds.auxiliarys.MapMath;
	import worlds.roles.PlayerPool;
	import worlds.roles.animations.AvatarFactory;
	import worlds.roles.animations.PlayerAnimation;
	import worlds.roles.animations.PlayerAnimationPool;
	import worlds.roles.cores.Player;
	import worlds.roles.cores.SelfPlayer;

	import flash.events.Event;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-18
	// ============================
	public class PlayerFactory
	{
		/** 单例对像 */
		private static var _instance : PlayerFactory;

		/** 获取单例对像 */
		public static  function get instance() : PlayerFactory
		{
			if (_instance == null)
			{
				_instance = new PlayerFactory(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var playerPool : PlayerPool;
		private var playerAnimationPool : PlayerAnimationPool;
		private var avatarFactory : AvatarFactory;

		function PlayerFactory(singleton : Singleton) : void
		{
			singleton;
			playerPool = PlayerPool.instance;
			playerAnimationPool = PlayerAnimationPool.instance;
			avatarFactory = AvatarFactory.instance;
		}

		public function makeSelfPlayer(playerId : int, name : String, colorStr : String, heroId : int, clothId : int, rideId : int) : SelfPlayer
		{
			var player : SelfPlayer = SelfPlayer.instance;
			var playerAnimation : PlayerAnimation = playerAnimationPool.getObject();
			var avatar : AvatarPlayer = avatarFactory.makePlayer(heroId, clothId, rideId, name, colorStr);
			avatar.source = playerId;
			player.initialize();
			playerAnimation.reset(avatar, name, colorStr);
			player.setAnimation(playerAnimation);
			if(MapUtil.currentMapStruct.hasMask) player.setNeedMask(true);
			return player;
		}

		public function makePlayer(playerId : int, name : String, colorStr : String, heroId : int, clothId : int, rideId : int) : Player
		{
			var player : Player = playerPool.getObject();
			var playerAnimation : PlayerAnimation = playerAnimationPool.getObject();
			var avatar : AvatarPlayer = avatarFactory.makePlayer(heroId, clothId, rideId, name, colorStr);
			avatar.source = playerId;
			avatar.addEventListener("clickPlayer", onClickPlayer);
			avatar.addEventListener("callback", onPlayerCallback);
			player.initialize();
			playerAnimation.reset(avatar, name, colorStr);
			player.setAnimation(playerAnimation);
			if(MapUtil.currentMapStruct.hasMask) player.setNeedMask(true);
			player.addToLayer();
			return player;
		}

		private function onPlayerCallback(event : Event) : void
		{
			var avatar : AvatarThumb = event.target as AvatarThumb;
			avatar.source = null;
			avatar.removeEventListener("clickPlayer", onClickPlayer);
			avatar.removeEventListener("callback", onPlayerCallback);
		}

		private function onClickPlayer(event : Event) : void
		{
			if(MMouse.enableWalk == false) return;
			var avatar : AvatarThumb = event.currentTarget as AvatarThumb;
			var playerId : int = avatar.source;
			trace("onClickPlayer", playerId);
			var x : int = avatar.x + MapMath.randomPlusMinus(60);
			var y : int = avatar.y + MapMath.randomPlusMinus(60);
			MTo.toPoint(x, y, MPlayer.onClickShowInfo, [playerId]);
		}
	}
}
class Singleton
{
}