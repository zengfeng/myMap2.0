package worlds.apis
{
	import game.manager.ViewManager;

	import worlds.auxiliarys.mediators.MSignal;
	import worlds.mediators.PlayerMediator;
	import worlds.roles.cores.Player;
	import worlds.roles.structs.PlayerStruct;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	// ============================
	public class MPlayer
	{
		/** 安装完成 */
		public static const sInstallComplete : MSignal = PlayerMediator.playerInstalled;
		/** 卸载开始 */
		public static const sDestory : MSignal = PlayerMediator.playerDestory;

		/** 获取玩家 */
		public static function getPlayer(playerId : int) : Player
		{
			return PlayerMediator.getPlayer.call(playerId);
		}

		/** 获取数据结构 */
		public static function getStruct(playerId : int) : PlayerStruct
		{
			return PlayerMediator.getStruct.call(playerId);
		}
		
		// =================
		// 监听
		// =================
		/** 添加安装回调 */
		public static function addInstallCall(playerId : int, callFun : Function, callFunArgs : Array = null) : void
		{
			PlayerMediator.cAddPlayerInstallListener.call(playerId, callFun, callFunArgs);
		}

		/** 移除安装回调 */
		public static function removeInstallCall(playerId : int, callFun : Function) : void
		{
			PlayerMediator.cRemovePlayerInstallListener.call(playerId, callFun);
		}

		/** 添加卸载回调 */
		public static function addDestoryCall(playerId : int, callFun : Function, callFunArgs : Array = null) : void
		{
			PlayerMediator.cAddPlayerDestoryistener.call(playerId, callFun, callFunArgs);
		}

		/** 移除卸载回调 */
		public static function removeDestoryCall(playerId : int, callFun : Function) : void
		{
			PlayerMediator.cRemovePlayerDestoryistener.call(playerId, callFun);
		}

		public static function onClickShowInfo(playerId : int) : void
		{
			var playerStruct : PlayerStruct = getStruct(playerId);
			if (!ViewManager.otherPlayerPanel || !playerStruct) return;
			var obj : Object = new Object();
			obj["id"] = playerStruct.id;
			obj["name"] = playerStruct.name;
			obj["heroId"] = playerStruct.heroId;
			obj["level"] = playerStruct.level;
			ViewManager.otherPlayerPanel.source = obj;
			ViewManager.otherPlayerPanel.show();
		}
	}
}
