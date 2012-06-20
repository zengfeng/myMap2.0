package worlds.apis
{
	import worlds.auxiliarys.MapPoint;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.mediators.SelfMediator;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	// ============================
	public class MSelfPlayer
	{
		public static var sInstallComplete : MSignal = SelfMediator.sInstallComplete;
		public static var sWalkStart : MSignal = SelfMediator.sWalkStart;
		public static var sWalkEnd : MSignal = SelfMediator.sWalkEnd;
		public static var sTransport : MSignal = SelfMediator.sTransport;

		public static function getPosition() : MapPoint
		{
			return SelfMediator.cbPosition.call();
		}
	}
}
