package worlds.apis
{
	import worlds.mediators.MapMediator;
	import worlds.auxiliarys.mediators.MSignal;
	import game.module.mapWorld.WorldMapController;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	// ============================
	public class MWorld
	{
		/** 地图安装完成 */
		public static var sInstallComplete : MSignal = MapMediator.sInstallComplete;
		/** 地图卸载完成 */
		public static var sUninstallComplete : MSignal = MapMediator.sUnstallComplete;
		

		/* -----------------------------  发送协议  ----------------------------- */
		/** 离开地图 */
		public static function csLeaveMap() : void
		{
			MapMediator.csLeaveMap.call();
		}

		/** 切换地图 */
		public static function csChangeMap(mapId : int) : void
		{
			MapMediator.csChangeMap.call(mapId);
		}

		/** 传送 */
		public static function csTransport(toX : int, toY : int, toMapId : int) : void
		{
			MapMediator.csTransport.call(toX, toY, toMapId);
		}
		
		/** 使用传送阵切换地图 */
		public static function csUseGateChangeMap(gateId:int):void
		{
			MapMediator.csUseGateChangeMap.call(gateId);
		}
		
		/** 打开世界地图并前住某个地图 */
		public static function worldMapTo(toMapId:int):void
		{
			WorldMapController.instance.toMap(toMapId, true);
		}
	}
}
