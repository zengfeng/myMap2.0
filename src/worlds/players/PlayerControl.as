package worlds.players
{
	import worlds.auxiliarys.listeners.Listener;
	import worlds.WorldStartup;
	import worlds.maps.resets.IReset;
	import worlds.mediators.PlayerMediator;
	import worlds.roles.cores.Player;
	import worlds.roles.cores.SelfPlayer;
	import worlds.roles.structs.PlayerStruct;

	import mx.core.Singleton;

	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-25
	 */
	public class PlayerControl
	{
		/** 单例对像 */
		private static var _instance : PlayerControl;

		/** 获取单例对像 */
		public static  function get instance() : PlayerControl
		{
			if (_instance == null)
			{
				_instance = new PlayerControl(new Singleton());
			}
			return _instance;
		}

		function PlayerControl(singleton : Singleton) : void
		{
			singleton;
			PlayerMediator.getPlayer.register(getPlayer);
			PlayerMediator.cAddPlayerInstallListener.register(installListener.add);
			PlayerMediator.cRemovePlayerInstallListener.register(installListener.remove);
			PlayerMediator.cAddPlayerDestoryistener.register(destoryListener.add);
			PlayerMediator.cRemovePlayerDestoryistener.register(destoryListener.remove);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var playerData : PlayerData = PlayerData.instance;
		private var playerFactory : PlayerFactory = PlayerFactory.instance;
		private var selfPlayerManager : SelfManager = SelfManager.instance;
		private var playerDic : Dictionary = new Dictionary();
		private var moudle : IReset;
		private var installListener : Listener = new Listener();
		private var destoryListener : Listener = new Listener();
		private var tempKeyArr : Array = new Array();

		public function setMoudle(moudle : IReset) : void
		{
			this.moudle = moudle;
		}

		public function getPlayer(playerId : int) : Player
		{
			return playerDic[playerId];
		}

		// ================
		// 自己玩家
		// ================
		/** 安装自己 */
		public function installSelf() : void
		{
			if (!playerData.hasSelf || !playerData.selfInfoNewest || playerData.selfInstalled)
			{
				return;
			}
			var playerStruct : PlayerStruct = playerData.self;
			selfPlayerManager.reset();
			var player : Player = SelfPlayer.instance;
			playerDic[playerStruct.id] = player;
			PlayerMediator.selfInstalled.dispatch();
			moudle.initPlayerModel(playerStruct.id, playerStruct.model);
			installListener.call(playerStruct.id);
		}

		/** 卸载自己 */
		public function uninstallSelf() : void
		{
			selfPlayerManager.cache();
			destoryListener.call(WorldStartup.userId);
			installListener.clearID(WorldStartup.userId);
			destoryListener.clearID(WorldStartup.userId);
			delete playerDic[WorldStartup.userId];
		}

		// ================
		// 其他玩家
		// ================
		/** 安装 */
		public function installPlayer(playerStruct : PlayerStruct) : void
		{
			var player : Player = playerFactory.makePlayer(playerStruct.id, playerStruct.name, playerStruct.colorStr, playerStruct.heroId, playerStruct.clothId, playerStruct.rideId);
			player.resetPlayer(playerStruct.id, playerStruct.name, playerStruct.colorStr, playerStruct.heroId, playerStruct.clothId, playerStruct.rideId);
			player.initPosition(playerStruct.x, playerStruct.y, playerStruct.speed, playerStruct.walking, playerStruct.walkTime, playerStruct.fromX, playerStruct.fromY, playerStruct.toX, playerStruct.toY);
			playerDic[playerStruct.id] = player;
			PlayerMediator.playerInstalled.dispatch(playerStruct.id);
			moudle.initPlayerModel(playerStruct.id, playerStruct.model);
			installListener.call(playerStruct.id);
		}

		/** 卸载 */
		public function uninstallPlayer(playerId : int) : void
		{
			PlayerMediator.playerDestory.dispatch(playerId);
			var player : Player = playerDic[playerId];
			player.destory();
			destoryListener.call(playerId);
			installListener.clearID(playerId);
			destoryListener.clearID(playerId);
			delete playerDic[playerId];
		}

		/** 安装所有可安装的 */
		public function installOtherPlayers() : void
		{
			var list : Vector.<PlayerStruct>= playerData.waitInstallInfoNewestList;
			while (list.length > 0)
			{
				installPlayer(list.shift());
			}
		}

		/** 卸载所有的玩家 */
		public function unstallOtherPlayers() : void
		{
			delete playerDic[WorldStartup.userId];
			var player : Player;
			var key : String;
			for (key in playerDic)
			{
				tempKeyArr.push(key);
			}

			while (tempKeyArr.length > 0)
			{
				key = tempKeyArr.shift();
				player = playerDic[key];
				player.destory();
				delete playerDic[key];
			}
			
			installListener.clearAll();
			destoryListener.clearAll();
		}

		// ================
		// 玩家操作
		// ================
		/** 玩家走路 */
		public function playerWalk(playerId : int, toX : int, toY : int, hasFrom : Boolean, fromX : int, fromY : int) : void
		{
			var player : Player = playerDic[playerId];
			player.walkFromTo(toX, toY, hasFrom, fromX, fromY);
		}

		/** 玩家传送 */
		public function playerTransport(playerId : int, toX : int, toY : int) : void
		{
			var player : Player = playerDic[playerId];
			// var distance:Number = MapMath.distance(player.x, player.y, toX, toY);
			// if(distance < 50) return;
			player.transportTo(toX, toY);
		}

		/** 玩家坐下 */
		public function sitDown(playerId : int) : void
		{
			var player : Player = playerDic[playerId];
			player.sitDown();
		}

		/** 玩家站起 */
		public function sitUp(playerId : int) : void
		{
			var player : Player = playerDic[playerId];
			player.sitUp();
		}

		// ================
		// 玩家属性
		// ================
		/** 玩家换衣服 */
		public function changeCloth(playerId : int, clothId : int) : void
		{
			var player : Player = playerDic[playerId];
			player.changeCloth(clothId);
		}

		/** 玩家换坐骑 */
		public function changeRide(playerId : int, rideId : int) : void
		{
			var player : Player = playerDic[playerId];
			player.rideUp(rideId);
		}

		// ================
		// 龟拜模式
		// ================
		public function convoyModelIn(playerId : int, quality : int) : void
		{
			quality;
			var player : Player = playerDic[playerId];
			player.convoyModelIn(1, "龟龟", "#693231", false);
		}

		public function convoyModelOut(playerId : int) : void
		{
			var player : Player = playerDic[playerId];
			player.convoyModelOut();
		}

		public function convoyChangeSpeed(playerId : int, speedModel : int) : void
		{
			var player : Player = playerDic[playerId];
			if (speedModel > 4)
			{
				player.convoySpeedFast();
			}
			else
			{
				player.convoySpeedSlowly();
			}
		}
	}
}
