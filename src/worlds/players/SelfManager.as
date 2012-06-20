package worlds.players
{
	import worlds.roles.proessors.walks.MoveProessorType;
	import worlds.mediators.MapMediator;
	import worlds.mediators.SelfMediator;
	import worlds.roles.cores.SelfPlayer;
	import worlds.roles.structs.PlayerStruct;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-5
	// ============================
	public class SelfManager
	{
		/** 单例对像 */
		private static var _instance : SelfManager;

		/** 获取单例对像 */
		static public function get instance() : SelfManager
		{
			if (_instance == null)
			{
				_instance = new SelfManager(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var player : SelfPlayer;
		private var playerStruct : PlayerStruct;

		function SelfManager(singleton : Singleton) : void
		{
			singleton;
			playerStruct = GlobalPlayers.instance.self;
		}

		/** 创建 */
		private function create() : void
		{
			player = PlayerFactory.instance.makeSelfPlayer(playerStruct.id, playerStruct.name, playerStruct.colorStr, playerStruct.heroId, playerStruct.clothId, playerStruct.rideId);
		}

		/** 重设 */
		public function reset() : void
		{
			if (player == null)
			{
				create();
			}
			else
			{
				player.changeCloth(playerStruct.clothId);
				player.rideUp(playerStruct.rideId);
			}
			player.resetPlayer(playerStruct.id, playerStruct.name, playerStruct.colorStr, playerStruct.heroId, playerStruct.clothId, playerStruct.rideId);
			player.initPosition(playerStruct.x, playerStruct.y, playerStruct.speed + 1, playerStruct.walking, playerStruct.walkTime, playerStruct.fromX, playerStruct.fromY, playerStruct.toX, playerStruct.toY, MoveProessorType.FRAME);
			player.cacheOut();
			MapMediator.sMouseWalk.add(player.walkPathTo);
			SelfMediator.cWalkPathTo.register(player.walkPathTo);
			SelfMediator.cWalkStop.register(player.walkStop);
			SelfMediator.sInstallComplete.dispatch();
		}

		/** 缓存 */
		public function cache() : void
		{
			if (player == null) return;
			player.cacheIn();
			MapMediator.sMouseWalk.remove(player.walkPathTo);
		}
	}
}
class Singleton
{
}