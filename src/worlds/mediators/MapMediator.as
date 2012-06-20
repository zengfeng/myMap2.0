package worlds.mediators
{
	import worlds.auxiliarys.mediators.Callback;
	import com.signalbus.Signal;

	import worlds.auxiliarys.mediators.Call;
	import worlds.auxiliarys.mediators.MSignal;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	// ============================
	public class MapMediator
	{
		/**  暂停安装*/
		public static const pauseInstall:MSignal = new MSignal();
		/** 安装args=[mapId, initX, initY] */
		public static const sInstall : MSignal = new MSignal(int, int, int);
		public static const sInstallComplete : MSignal = new MSignal();
		public static const sUnstallComplete:MSignal = new MSignal();
		// ---------------------------------------
		/** 是否绑定卷动频幕args=[value:Boolean] */
		public static const cBindScorll : Call = new Call();
		/** 频幕截图args=[centerX:int, centerY:int, width:uint = 0, height:uint = 0] */
		public static const cbPrintScreen : Callback = new Callback();
		// ---------------------------------------
		public static const cMouseEnabled : Call = new Call();
		public static const sMouseWalk : Signal = new Signal(int, int);
		
		
		/** 离开地图 */
		public static const csLeaveMap:Call = new Call();
		/** 切换地图args=[mapId] */
		public static const csChangeMap:Call = new Call();
		/** 切换地图args=[toX : int, toY : int, toMapId : int] */
		public static const csTransport:Call = new Call();
		/** 使用传送阵切换地图args=[gateId] */
		public static const csUseGateChangeMap:Call = new Call();
		
	}
}
